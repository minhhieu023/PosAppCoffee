import 'package:SPK_Coffee/Components/Hamberger/Hamberger.dart';
import 'package:SPK_Coffee/Components/HomeScreen/DashBoard.dart';
import 'package:SPK_Coffee/Utils/Feature.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppBarCus.dart';

class MainHomeScreen extends StatefulWidget {
  Function onFloatButtonPressed;
  Function onAddButtonPressed;
  MainHomeScreen({this.onAddButtonPressed, this.onFloatButtonPressed, key})
      : super(key: key);
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  double height = AppBar().preferredSize.height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return mainPage(
      onAddButtonPressed: widget.onAddButtonPressed,
      onFloatButtonPressed: widget.onFloatButtonPressed,
    );
  }
}

Widget mainPage({
  Function onAddButtonPressed,
  Function onFloatButtonPressed,
}) {
  return Builder(builder: (context) {
    return Scaffold(
      appBar: appBar(),
      body: DashBoard(),
      // drawerScrimColor: Colors.blueAccent,
      drawer: Hamberger(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.info),
        onPressed: () {
          onFloatButtonPressed();
        },
      ),
    );
  });
}
