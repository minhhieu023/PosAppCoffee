import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/Models/OrderList.dart';
import 'package:flutter/material.dart';
import 'package:screen_loader/screen_loader.dart';

class DurationSortWid extends StatefulWidget {
  final List<Order> orderList;
  DurationSortWid({this.orderList});
  @override
  _DurationSortWidState createState() => _DurationSortWidState();
}

class _DurationSortWidState extends State<DurationSortWid>
    with ScreenLoader<DurationSortWid> {
  OrderList orderList;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget screen(BuildContext context) {
    // TODO: implement screen
    return ListView(
      children: [Text("")],
    );
  }
}
