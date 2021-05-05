import 'package:SPK_Coffee/Utils/StaticValue.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget appBar() {
  return AppBar(
    backgroundColor: mPrimaryColor,

    title: Text(
      "SPK Coffee",
      style: TextStyle(color: Colors.white),
    ),
    centerTitle: true,

    // centerTitle: true,
  );
}
