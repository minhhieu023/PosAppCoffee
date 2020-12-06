import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/Models/OrderList.dart';
import 'package:flutter/material.dart';

class MainCashNav extends StatefulWidget {
  final OrderList orderList;
  MainCashNav({this.orderList});
  @override
  _MainCashNavState createState() => _MainCashNavState();
}

class _MainCashNavState extends State<MainCashNav> {
  OrderList list;
  List<Order> orders = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = widget.orderList;
    setup();
  }

  void setup() {
    orders.clear();
    if (list != null) {
      list.data.forEach((order) {
        orders.add(order);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cashier"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return Container(
              child: Text("Order: ${orders[index].id}"),
            );
          },
        ),
      ),
    );
  }
}
