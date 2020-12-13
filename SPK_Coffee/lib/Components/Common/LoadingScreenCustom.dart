import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loadingScreen() {
  return Container(
    color: Colors.white10,
    child: SpinKitFadingCircle(),
  );
}
