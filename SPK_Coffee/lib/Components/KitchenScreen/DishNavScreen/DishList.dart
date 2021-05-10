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
  int popUpValue = 0;
  OrderList saveInstanceOrderList;
  List<Widget> title = [Text("Dish"), Text("Sort by duration")];
  void setProcessState() async {}
  void getAllOrder() {
    this.performFuture(() {
      setStateIfMounted(() {
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
      SocketManagement().makeMessage("dishScreenUpdatePayment",
          isHaveData: true, data: {"id": id});
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

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    SocketManagement().addListener("updateSort", extensionFunc: getAllOrder);
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

  Widget customPopMenuBtn() {
    return PopupMenuButton(
      onSelected: (value) {
        setState(() {
          isSort = value == 0 ? true : false;
        });
      },
      itemBuilder: (context) {
        return <PopupMenuItem>[
          new PopupMenuItem(
            child: Text("Sort by duration"),
            value: 0,
          ),
          new PopupMenuItem(
            child: Text("Sort by dish"),
            value: 1,
          )
        ];
      },
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
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: () {
                print("floatting action button");
              },
            ),
            appBar: AppBar(
              actions: [customPopMenuBtn()],
              title: !isSort ? title[0] : title[1],
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
                    orders: orderList,
                    orderList: snapshot.data,
                    getProductNameAndDuration: getProductNameAndDuration,
                    changeStateOrderDetails: changeStateOrderDetails,
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

  setStateIfMounted(f) {
    if (mounted) {
      setState(f);
    }
  }

  @override
  Widget build(BuildContext context) {
    processColors = workColor[widget.order.details[widget.index].state];
    return Material(
      child: Slidable(
        actionExtentRatio: 0.2,
        controller: widget.slidableController,
        key: new Key(widget.order.id),
        child: Container(
          margin: EdgeInsets.only(bottom: 5),
          // margin: EdgeInsets.only(top: 5),
          // padding: EdgeInsets.all(5),
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.12
              : MediaQuery.of(context).size.height * 0.18,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
                // changes position of shadow
              ),
            ],
          ),
          // decoration: BoxDecoration(
          //   border: Border.all(width: 1, color: Colors.black),
          // ),
          // height: MediaQuery.of(context).size.height * 0.15,
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
                              "${StaticValue.svPath}${widget.productInfo['image']}",
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
                                      "Process duration: ${widget.totalProcessTime}"),
                                  Text(
                                      "${formatDateToString(widget.order.details[widget.index].createdAt)}")
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
            margin: EdgeInsets.only(bottom: 5, right: 2),
            // margin: EdgeInsets.only(top: 5),
            // padding: EdgeInsets.all(5),
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.12
                : MediaQuery.of(context).size.height * 0.18,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                  // changes position of shadow
                ),
              ],
            ),
            child: IconSlideAction(
              caption: "Ready",
              color: Colors.greenAccent,
              icon: Icons.check,
              onTap: () async {
                bool result = await widget.changeStateOrderDetails(
                    widget.order.details[widget.index].id, "ready");
                if (result) {
                  SocketManagement().makeMessage("getUpdateDishKitchen");

                  setStateIfMounted(() {
                    processColors = workColor['ready'];
                  });
                }
              },
            ),
          )
        ],
        secondaryActions: [
          Container(
            margin: EdgeInsets.only(bottom: 5, left: 2),
            // margin: EdgeInsets.only(top: 5),
            // padding: EdgeInsets.all(5),
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.12
                : MediaQuery.of(context).size.height * 0.18,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                  // changes position of shadow
                ),
              ],
            ),
            child: IconSlideAction(
              color: Colors.cyan,
              caption: "Process",
              icon: Icons.access_alarm,
              onTap: () async {
                bool result = await widget.changeStateOrderDetails(
                    widget.order.details[widget.index].id, "processing");
                if (result) {
                  SocketManagement().makeMessage("getUpdateDishKitchen");

                  setStateIfMounted(() {
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
