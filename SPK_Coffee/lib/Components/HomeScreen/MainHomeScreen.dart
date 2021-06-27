import 'package:SPK_Coffee/Components/Hamburger/Hamberger.dart';
import 'package:SPK_Coffee/Components/HomeScreen/DashBoard.dart';
import 'package:SPK_Coffee/Models/ProviderModels/UserProvider.dart';
import 'package:SPK_Coffee/Utils/Feature.dart';
import 'package:SPK_Coffee/Utils/StaticValue.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppBarCus.dart';

class MainHomeScreen extends StatefulWidget {
  final Function onFloatButtonPressed;
  final Function onAddButtonPressed;
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: mPrimaryColor,
        title: Text(
          userProvider.user.storeName,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,

        // centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: (MediaQuery.of(context).size.height - kToolbarHeight),
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
  }
}
