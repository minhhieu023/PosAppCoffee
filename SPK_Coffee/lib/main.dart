import 'package:SPK_Coffee/Components/HomeScreen/MainHomeScreen.dart';
import 'package:SPK_Coffee/Components/KitchenScreen/MainKitChenScreen.dart';
import 'package:SPK_Coffee/Components/ServiceScreen/MainServiceScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final bool ischoose = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => mainPage(),
        '/Services': (context) => MainServiceScreen(),
        '/Kitchen': (context) => MainKitchenScreen(),
      },
    );
  }
}
