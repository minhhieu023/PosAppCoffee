import 'package:SPK_Coffee/Components/HomeScreen/MainHomeScreen.dart';
import 'package:SPK_Coffee/Components/KitchenScreen/MainKitChenScreen.dart';
import 'package:SPK_Coffee/Components/ServiceScreen/MainServiceScreen.dart';
import 'package:SPK_Coffee/Components/ServiceScreen/OrderScreen.dart';
import 'package:SPK_Coffee/Models/Product.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:flutter/material.dart';

import 'Services/SocketManager.dart';

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
  SocketManagement _socketManagement = new SocketManagement();

  @override
  void initState() {
    super.initState();
    _socketManagement.createSocketConnection();
  }

  void onFloatButtonPressed() {
    _socketManagement.socket
        .emit('send notification', 'A1 table have customer!');
  }

  void onAddButtonPressed() {
    _socketManagement.socket.emit('notify guest', 'Guest comming at A0 Table');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.blueAccent,
      // theme: ThemeData(primaryColor: Colors.blue[100]),
      initialRoute: '/',
      routes: {
        '/': (context) => mainPage(
            onAddButtonPressed: onAddButtonPressed,
            onFloatButtonPressed: onFloatButtonPressed),
        '/Services': (context) => MainServiceScreen(),
        '/Kitchen': (context) => MainKitchenScreen(),
        '/Order': (context) => OrderScreen()
      },
    );
  }
}
