import 'package:SPK_Coffee/Components/Hamberger/Hamberger.dart';
import 'package:SPK_Coffee/Components/HomeScreen/DashBoard.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'AppBarCus.dart';

class MainHomeScreen extends StatefulWidget {
  MainHomeScreen({Key key}) : super(key: key);

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  double height = AppBar().preferredSize.height;
  @override
  Widget build(BuildContext context) {
    return mainPage();
  }
}

Widget mainPage() {
  return Builder(builder: (context) {
    return Scaffold(
      appBar: appBar(),
      body: dashBoard(),
      // drawerScrimColor: Colors.blueAccent,
      drawer: Hamberger(),
    );
  });
}
