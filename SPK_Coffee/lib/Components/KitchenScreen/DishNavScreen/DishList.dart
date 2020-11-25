import 'package:SPK_Coffee/Components/KitchenScreen/DishNavScreen/Sorts/SortByDuration.dart';
import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/Models/OrderList.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:SPK_Coffee/Services/SocketManager.dart';
import 'package:SPK_Coffee/Utils/FormatString.dart';
import 'package:SPK_Coffee/Utils/StaticValue.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:screen_loader/screen_loader.dart';

class DishList extends StatefulWidget {
  final Function(Function) getSortScreen;
  DishList({this.getSortScreen});
  @override
  _DishListState createState() => _DishListState();
}

class _DishListState extends State<DishList> with ScreenLoader<DishList> {
  final SlidableController slidableController = SlidableController();
  bool isSort = false;
  Future<OrderList> orderList;
  OrderList saveInstanceOrderList;
  void setProcessState() async {}
  void getAllOrder() {
    this.performFuture(() {
      setState(() {
        orderList = ServiceManager().getActiveProducts();
      });
      return orderList;
    });
  }

  void buildSnackBar({String content, int second = 2}) {
    SnackBar snackBar = SnackBar(
        // width: MediaQuery.of(context).size.width * 0.1,
        duration: Duration(seconds: second),
        content: Container(
          child: Text(content),
        ));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<bool> changeStateOrderDetails(String id, String state) async {
    bool finalResult = await this.performFuture(() async {
      return await ServiceManager().updateOrderDetailsState(id, state);
    });
    if (finalResult) {
      buildSnackBar(content: "Change state success!", second: 2);
      SocketManagement().makeMessage("makeUpdateOrderScreen");
    }
    return finalResult;
  }

  changeSortScreen() {
    setState(() {
      isSort = isSort ? false : true;
    });
  }

  setStateIfMounted(f) {
    if (mounted) {
      setState(f);
    }
  }

  Map<String, String> getProductNameAndDuration(
      OrderList list, String productId) {
    Map<String, String> result = {};
    list.productsInfo.forEach((product) {
      if (product.id == productId) {
        result = {
          'name': product.productName,
          'duration': product.processDuration,
          'image': product.mainImage
        };
      }
    });
    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllOrder();
  }

  @override
  Widget loader() {
    // TODO: implement loader
    return AlertDialog(
      title: Text('Wait.. Loading data..'),
    );
  }

  onSortPressed() {}
  @override
  Widget screen(BuildContext context) {
    return FutureBuilder<OrderList>(
      future: orderList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          saveInstanceOrderList = snapshot.data;
          List<Order> orderList = snapshot.data.data;
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    icon: Icon(Icons.sort),
                    onPressed: () {
                      setState(() {
                        isSort = isSort ? false : true;
                      });
                    })
              ],
              title: Text("Dish"),
            ),
            body: !isSort
                ? ListView(
                    children: orderList.map((order) {
                      return Container(
                          // margin: EdgeInsets.only(top: 20),
                          child: ListView.builder(
                        physics: new NeverScrollableScrollPhysics(),
                        itemCount: order.details.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Map<String, String> productInfo =
                              getProductNameAndDuration(snapshot.data,
                                  order.details[index].productId);
                          String totalProcessTime = sumTime(
                              [productInfo['duration']],
                              [order.details[index].amount]);
                          return OrderDtProWid(
                              slidableController: slidableController,
                              order: order,
                              index: index,
                              productInfo: productInfo,
                              totalProcessTime: totalProcessTime,
                              changeStateOrderDetails: changeStateOrderDetails);
                        },
                      ));
                    }).toList(),
                  )
                : DurationSortWid(
                    orderList: orderList,
                  ),
          );
        }
        return Text("");
      },
    );
  }
}

class OrderDtProWid extends StatefulWidget {
  final SlidableController slidableController;
  final Order order;
  final Map<String, String> productInfo;
  final int index;
  final Function(String, String) changeStateOrderDetails;
  final String totalProcessTime;
  OrderDtProWid(
      {this.slidableController,
      this.order,
      this.index,
      this.productInfo,
      this.totalProcessTime,
      this.changeStateOrderDetails});

  @override
  _OrderDtProWidState createState() => _OrderDtProWidState();
}

class _OrderDtProWidState extends State<OrderDtProWid> {
  Color processColors;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    processColors = workColor[widget.order.details[widget.index].state];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Slidable(
        actionExtentRatio: 0.2,
        controller: widget.slidableController,
        key: new Key(widget.order.id),
        child: Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
          ),
          height: MediaQuery.of(context).size.height * 0.15,
          child: Stack(
            children: [
              Container(
                color: processColors.withOpacity(0.5),
              ),
              InkWell(
                  splashColor: Colors.lightGreen,
                  onTap: () {
                    print("object");
                  },
                  child: Container(
                    padding: EdgeInsets.only(bottom: 5),
                    margin: EdgeInsets.only(left: 5, top: 5),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(300),
                            child: Image.network(
                              "${StaticValue.path}${widget.productInfo['image']}",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${widget.productInfo['name']}",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  " X${widget.order.details[widget.index].amount}",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.red),
                                )
                              ],
                            ),
                            Table(
                              children: [
                                TableRow(children: [
                                  Text(
                                      "Process duration: $widget.totalProcessTime"),
                                  Text(
                                      "Order time: ${formatDateToString(widget.order.details[widget.index].createdAt)}")
                                ])
                              ],
                            ),
                            Text(
                              "From order: ${widget.order.details[widget.index].orderId}",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ))
                      ],
                    ),
                  )),
            ],
          ),
        ),
        actionPane: SlidableDrawerActionPane(),
        dismissal: SlidableDismissal(
          child: SlidableDrawerDismissal(),
          onDismissed: (actionType) {
            print("dissmised");
          },
          dismissThresholds: <SlideActionType, double>{
            SlideActionType.secondary: 1.0
          },
        ),
        actions: [
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(width: 1),
                    left: BorderSide(width: 1),
                    bottom: BorderSide(width: 1))),
            child: IconSlideAction(
              caption: "Ready",
              color: Colors.greenAccent,
              icon: Icons.check,
              onTap: () async {
                bool result = await widget.changeStateOrderDetails(
                    widget.order.details[widget.index].id, "ready");
                if (result) {
                  setState(() {
                    processColors = workColor['ready'];
                  });
                }
              },
            ),
          )
        ],
        secondaryActions: [
          Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(width: 1),
                    right: BorderSide(width: 1),
                    bottom: BorderSide(width: 1))),
            height: MediaQuery.of(context).size.height * 0.15,
            child: IconSlideAction(
              color: Colors.cyan,
              caption: "Process",
              icon: Icons.access_alarm,
              onTap: () async {
                bool result = await widget.changeStateOrderDetails(
                    widget.order.details[widget.index].id, "processing");
                if (result) {
                  setState(() {
                    processColors = workColor['processing'];
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
