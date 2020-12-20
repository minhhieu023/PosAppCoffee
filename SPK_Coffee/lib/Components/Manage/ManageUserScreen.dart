import 'package:SPK_Coffee/Models/ProviderModels/EmployeeInformationProvider.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'EmployeeListView.dart';

class ManageUserScreen extends StatefulWidget {
  ManageUserScreen({Key key}) : super(key: key);

  @override
  _ManageUserScreenState createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Information"),
        centerTitle: true,
      ),
      body: EmployeeListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus),
        onPressed: () {
          print("OK");
        },
      ),
    );
  }
}
