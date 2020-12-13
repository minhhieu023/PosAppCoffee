import 'package:SPK_Coffee/Components/KitchenScreen/DishNavScreen/DishList.dart';
import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/Models/OrderDetail.dart';
import 'package:SPK_Coffee/Models/OrderList.dart';
import 'package:SPK_Coffee/Utils/FormatString.dart';
import 'package:SPK_Coffee/Utils/StaticValue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:screen_loader/screen_loader.dart';

class DurationSortWid extends StatefulWidget {
  final List<Order> orders;
  final OrderList orderList;
  final Function(String, String) changeStateOrderDetails;
  final Function(OrderList, String) getProductNameAndDuration;

  DurationSortWid(
      {this.orderList,
      this.orders,
      this.getProductNameAndDuration,
      this.changeStateOrderDetails});
  @override
  _DurationSortWidState createState() => _DurationSortWidState();
}

class _DurationSortWidState extends State<DurationSortWid>
    with ScreenLoader<DurationSortWid> {
  final SlidableController slidableController = SlidableController();
  OrderList orderList;
  List<Order> orders;
  List<OrderDetail> details = [];
  List<Map<String, dynamic>> fullOrderInfList = [];
  @override
  void initState() {
    super.initState();
    orders = widget.orders;
    orderList = widget.orderList;
    autoSortDuration();
  }

  void autoSortDuration() {
    List<Order> sortedOrders = [];
    List<Map<String, dynamic>> productDetailInfo = [];
    List<OrderDetail> orderDetails = [];
    orders.asMap().forEach((index, order) {
      order.details.asMap().forEach((j, orderDetail) {
        Map<String, String> detail = widget.getProductNameAndDuration(
            widget.orderList, orderDetail.productId);

        String totalDurInOneOrder =
            sumTime([detail['duration']], [orderDetail.amount]);
        // time.add(totalTime);
        int totalTime = int.parse(totalDurInOneOrder.split(':')[1] +
            totalDurInOneOrder.split(':')[2]);
        productDetailInfo.add({
          "detail": detail,
          "totalTime": totalTime,
          "order": order,
          "orderDetail": orderDetail
        });
      });
    });
    productDetailInfo.sort((a, b) => a["totalTime"].compareTo(b["totalTime"]));
    sortedOrders.clear();
    productDetailInfo.forEach((element) {
      sortedOrders.add(element["order"]);
      orderDetails.add(element["orderDetail"]);
    });
    setState(() {
      orders = sortedOrders;
      details = orderDetails;
      fullOrderInfList = productDetailInfo;
    });
  }

  @override
  Widget screen(BuildContext context) {
    // TODO: implement screen
    return ListView.builder(
      itemCount: details.length,
      itemBuilder: (context, index) {
        String totalProcessTime = sumTime(
            [fullOrderInfList[index]["detail"]['duration']],
            [fullOrderInfList[index]["orderDetail"].amount]);
        return OnlyDetailProductWid(
          index: index,
          productInfo: fullOrderInfList[index]["detail"],
          slidableController: slidableController,
          detail: details[index],
          changeStateOrderDetails: widget.changeStateOrderDetails,
          totalProcessTime: totalProcessTime,
        );
      },
    );
  }
}

class OnlyDetailProductWid extends StatefulWidget {
  final int index;
  final Map<String, dynamic> productInfo;
  final OrderDetail detail;
  final SlidableController slidableController;
  final Function(String, String) changeStateOrderDetails;
  final String totalProcessTime;
  OnlyDetailProductWid(
      {this.detail,
      this.slidableController,
      this.index,
      this.productInfo,
      this.changeStateOrderDetails,
      this.totalProcessTime});
  @override
  _OnlyDetailProductWidState createState() => _OnlyDetailProductWidState();
}

class _OnlyDetailProductWidState extends State<OnlyDetailProductWid> {
  Color processColors;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    processColors = workColor[widget.detail.state];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Slidable(
        actionExtentRatio: 0.2,
        controller: widget.slidableController,
        key: new Key(widget.detail.id),
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
                                  " X${widget.detail.amount}",
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
                                      "Order time: ${formatDateToString(widget.detail.createdAt)}")
                                ])
                              ],
                            ),
                            Text(
                              "From order: ${widget.detail.orderId}",
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
                    widget.detail.id, "ready");
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
                    widget.detail.id, "processing");
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
