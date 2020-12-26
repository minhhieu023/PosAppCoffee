import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/Models/OrderDetail.dart';
import 'package:SPK_Coffee/Models/OrderList.dart';
import 'package:SPK_Coffee/Services/SocketManager.dart';
import 'package:SPK_Coffee/Utils/FormatString.dart';
import 'package:flutter/material.dart';

class ProcessListWid extends StatefulWidget {
  final List<Order> orders;
  final OrderList list;
  final Function(String, String) updateOrderState;
  ProcessListWid({this.list, this.updateOrderState, this.orders});
  @override
  _ProcessListWidState createState() => _ProcessListWidState();
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

class _ProcessListWidState extends State<ProcessListWid> {
  List<Order> orderList = [];

  void filterList() {
    orderList.clear();
    if (widget.orders == null) {
      return;
    }
    widget.orders.forEach((item) {
      if (item.state == "processing") {
        orderList.add(item);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // orderList = widget.orders == null ? [] : widget.orders;
  }

  @override
  Widget build(BuildContext context) {
    filterList();
    return widget.orders != null
        ? ListView.builder(
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
                              icon: Icon(Icons.arrow_upward),
                              onPressed: () {
                                widget.updateOrderState(
                                    orderList[index].id, 'open');
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
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 25),
                                  ),
                                  flex: 2,
                                  fit: FlexFit.loose,
                                ),
                                Flexible(
                                    flex: 2,
                                    fit: FlexFit.tight,
                                    child: Text(
                                        "Order time: ${formatDateToString(orderList[index].date)} \nTime to make: ${getTotalTime(orderList[index].details, widget.list.productsInfo)}",
                                        style:
                                            TextStyle(color: Colors.black45)))
                              ],
                            )),
                        Flexible(
                          fit: FlexFit.tight,
                          child: IconButton(
                              icon: Icon(
                                Icons.arrow_right_sharp,
                                size: 50,
                              ),
                              onPressed: () async {
                                await widget.updateOrderState(
                                    orderList[index].id, 'ready');
                                SocketManagement()
                                    .makeMessage("getUpdateAllKitchen");
                              }),
                          flex: 1,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: orderList.length,
          )
        : Text("");
  }
}
/**
ListTile(
            hoverColor: Colors.blue,
            isThreeLine: true,
            tileColor: Color.fromRGBO(143, 151, 164, 0.6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onTap: () {
              formatDateToString(orderList[index].date);
            },
            leading: Icon(
              Icons.ac_unit,
              size: 40,
            ),
            title: Text(
              "Order num: ${orderList[index].id}",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            subtitle: Text(
                "Order time: ${formatDateToString(orderList[index].date)} \nTime to make: ${getTotalTime(orderList[index].details, widget.list.productsInfo)}",
                style: TextStyle(color: Colors.white)),
            trailing: InkWell(
              child: Icon(Icons.account_balance),
            ),
          )

 */
