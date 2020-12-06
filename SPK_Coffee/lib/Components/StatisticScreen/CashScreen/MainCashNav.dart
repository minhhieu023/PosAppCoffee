import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/Models/OrderList.dart';
import 'package:SPK_Coffee/Utils/UtilitiesFunc.dart';
import 'package:flutter/material.dart';

class MainCashNav extends StatefulWidget {
  final Future<OrderList> orderList;
  MainCashNav({this.orderList});
  @override
  _MainCashNavState createState() => _MainCashNavState();
}

class _MainCashNavState extends State<MainCashNav> {
  Future<OrderList> list;
  List<Order> orders = [];
  Screen screen = new Screen();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = widget.orderList;
    // setup();
  }

  void setup() {
    if (list != null) {
      list = widget.orderList;
    }
  }

  void getOrders(List<Order> orderList) {
    orders.clear();
    orderList.forEach((order) {
      orders.add(order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OrderList>(
      future: list,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          getOrders(snapshot.data.data);
          if (MediaQuery.of(context).orientation == Orientation.portrait) {
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
        } else {
          return CircularProgressIndicator(
            backgroundColor: Colors.green,
          );
        }
      },
    );
  }
}

class LandScapeCashScreen extends StatefulWidget {
  @override
  _LandScapeCashScreenState createState() => _LandScapeCashScreenState();
}

class _LandScapeCashScreenState extends State<LandScapeCashScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
