import 'package:SPK_Coffee/Components/Hamburger/Hamberger.dart';
import 'package:SPK_Coffee/Components/HomeScreen/DashBoard.dart';
import 'package:SPK_Coffee/Utils/Feature.dart';
import 'package:flutter/cupertino.dart';

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

      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Container(
                height:
                    (MediaQuery.of(context).size.height - kToolbarHeight) * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child:
                          Text("Wellcome back", style: TextStyle(fontSize: 18)),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.width * 0.15,
                          child: CircleAvatar(
                            child: Icon(Icons.person, size: 50),
                          ),
                        ),
                        Text("Võ Minh Hiếu",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              height:
                  (MediaQuery.of(context).size.height - kToolbarHeight) * 0.8,
              child: DashBoard(),
            )
          ],
        ),
      ),
      // drawerScrimColor: Colors.blueAccent,
      drawer: Hamberger(),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.info),
      //   onPressed: () {
      //     onFloatButtonPressed();
      //   },
      // ),
    );
  });
}
