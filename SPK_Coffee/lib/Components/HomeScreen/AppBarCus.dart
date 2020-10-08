import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget appBar() {
  return AppBar(
    backgroundColor: Colors.white12,
    shadowColor: Colors.black12,
    title: Text(
      "SPK Coffee",
      style: TextStyle(color: Colors.blue),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: 15),
        child: CircleAvatar(),
      ),
    ],
    centerTitle: true,
    iconTheme: new IconThemeData(color: Colors.blueAccent),

    // centerTitle: true,
  );
}
