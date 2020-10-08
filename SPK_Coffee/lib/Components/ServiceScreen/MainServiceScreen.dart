import 'package:flutter/material.dart';

class MainServiceScreen extends StatefulWidget {
  @override
  _MainServiceScreenState createState() => _MainServiceScreenState();
}

class _MainServiceScreenState extends State<MainServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Service"),
        ),
        body: Container(child: Text("This is service")));
  }
}
