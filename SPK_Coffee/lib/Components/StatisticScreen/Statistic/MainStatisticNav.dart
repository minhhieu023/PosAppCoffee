import 'package:flutter/material.dart';

class MainStatisticsNav extends StatefulWidget {
  @override
  _MainStatisticsNavState createState() => _MainStatisticsNavState();
}

class _MainStatisticsNavState extends State<MainStatisticsNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics"),
      ),
      body: Container(
        child: Text("main screen"),
      ),
    );
  }
}
