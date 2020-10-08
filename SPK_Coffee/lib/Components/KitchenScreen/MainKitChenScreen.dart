import 'package:flutter/material.dart';

class MainKitchenScreen extends StatefulWidget {
  @override
  _MainKitchenScreenState createState() => _MainKitchenScreenState();
}

class _MainKitchenScreenState extends State<MainKitchenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Kitchen"),
        ),
        body: Container(child: Text("This is kitchen")));
  }
}
