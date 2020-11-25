import 'dart:io';
import 'package:SPK_Coffee/Components/HomeScreen/MainHomeScreen.dart';
import 'package:SPK_Coffee/Components/KitchenScreen/MainKitChenScreen.dart';
import 'package:SPK_Coffee/Components/LoginScreen/LoginScreen.dart';
import 'package:SPK_Coffee/Components/ServiceScreen/MainServiceScreen.dart';
import 'package:SPK_Coffee/Components/ServiceScreen/OrderScreen.dart';
import 'package:SPK_Coffee/Components/ServiceScreen/ProductInCartScreen.dart';
import 'package:flutter/material.dart';
// import 'Utils/Config.dart';
import 'Components/LoginScreen/LoginUi.dart';
import 'Services/SocketManager.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
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
      theme: new ThemeData(
        backgroundColor: Colors.white12,
        shadowColor: Colors.black12,
        brightness: Brightness.light,
        primaryColor: Colors.white70,
        //accentColor: Colors.blueAccent,
      ),
      // theme: ThemeData(primaryColor: Colors.blue[100]),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/Dashboard': (context) => MainHomeScreen(
              onAddButtonPressed: onAddButtonPressed,
              onFloatButtonPressed: onFloatButtonPressed,
            ),
        '/Services': (context) => MainServiceScreen(),
        '/Kitchen': (context) => MainKitchenScreen(),
        '/Order': (context) => OrderScreen(),
        '/Cart': (context) => ProductInCartScreen(),
      },
    );
  }
}
