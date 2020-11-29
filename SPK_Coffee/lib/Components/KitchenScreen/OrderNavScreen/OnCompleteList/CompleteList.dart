import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/Models/OrderDetail.dart';
import 'package:SPK_Coffee/Models/OrderList.dart';
import 'package:SPK_Coffee/Utils/FormatString.dart';
import 'package:flutter/material.dart';

class CompleteListWid extends StatefulWidget {
  final OrderList list;
  final Function(String, String) updateOrderState;
  CompleteListWid({this.list, this.updateOrderState});

  @override
  _CompleteListWidState createState() => _CompleteListWidState();
}

class _CompleteListWidState extends State<CompleteListWid> {
  List<Order> orderList = [];
  void filterList() {
    orderList.clear();
    widget.list.data.forEach((item) {
      if (item.state == "ready") {
        orderList.add(item);
      }
    });
  }

  String getTotalTime(
      List<OrderDetail> listDetails, List<ProductsInfo> productsInfo) {
    //get dish.
    List<String> idList = [];
    List<String> durations = [];
    List<int> amountList = [];
    listDetails.forEach((detail) {
      idList.add(detail.productId);
      amountList.add(detail.amount);
    });
    productsInfo.forEach((element) {
      if (idList.contains(element.id)) {
        durations.add(element.processDuration);
      }
    });
    return sumTime(durations, amountList);
  }

  @override
  Widget build(BuildContext context) {
    filterList();
    return ListView.builder(
      itemBuilder: (context, index) {
        return Material(
          child: Container(
            margin: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.5),
                border: Border.all(width: 2, color: Colors.black38),
                borderRadius: BorderRadius.circular(10)),
            child: InkWell(
              splashColor: Colors.green,
              onTap: () {
                print("tapped");
              },
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: IconButton(
                        icon: Icon(Icons.arrow_left),
                        iconSize: 50,
                        onPressed: () {
                          widget.updateOrderState(
                              orderList[index].id, 'processing');
                        }),
                    flex: 1,
                  ),
                  Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "Order num: ${orderList[index].id}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 25),
                            ),
                            flex: 2,
                            fit: FlexFit.loose,
                          ),
                          Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Text(
                                  "Order time: ${formatDateToString(orderList[index].date)} \nTime to make: ${getTotalTime(orderList[index].details, widget.list.productsInfo)}",
                                  style: TextStyle(color: Colors.black45)))
                        ],
                      )),
                  Flexible(
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_upward,
                          size: 50,
                        ),
                        onPressed: () {
                          widget.updateOrderState(orderList[index].id, 'open');
                        }),
                  )
                ],
              ),
            ),
          ),
        );
      },
      itemCount: orderList.length,
    );
  }
}