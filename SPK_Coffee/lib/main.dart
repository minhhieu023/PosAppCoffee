import 'dart:io';
import 'package:SPK_Coffee/Components/HomeScreen/MainHomeScreen.dart';
import 'package:SPK_Coffee/Components/KitchenScreen/MainKitChenScreen.dart';
import 'package:SPK_Coffee/Components/LoginScreen/LoginScreen.dart';
import 'package:SPK_Coffee/Components/ServiceScreen/MainServiceScreen.dart';
import 'package:SPK_Coffee/Components/ServiceScreen/OrderScreen.dart';
import 'package:SPK_Coffee/Components/ServiceScreen/ProductInCartScreen.dart';
import 'package:SPK_Coffee/Models/Category.dart';
import 'package:SPK_Coffee/Models/Product.dart';
import 'package:SPK_Coffee/Services/DataBaseManagement.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:flutter/material.dart';
import 'package:screen_loader/screen_loader.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  DataBaseManagement _db = new DataBaseManagement();
  final bool ischoose = false;
  SocketManagement _socketManagement = new SocketManagement();

  @override
  void initState() {
    super.initState();
    _socketManagement.createSocketConnection();
    testReference();
  }

  testReference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("key", "đây là chuỗi được lưu");
    String str = prefs.get("key");
    // prefs.remove("key");
    print("reference value là: $str");
  }

  void onFloatButtonPressed() {
    _socketManagement.socket
        .emit('send notification', 'A1 table have customer!');
  }

  void onAddButtonPressed() {
    _socketManagement.socket.emit('notify guest', 'Guest comming at A0 Table');
  }

  Future<Widget> loadFromFuture() async {
    await _db.initDB();
    // <fetch data from server. ex. login>
    await _db.dropTableIfExists("Products");
    Category futureGetCategory =
        await ServiceManager().getProductWithCategory();
    List<Products> productList = [];
    futureGetCategory.data.forEach((element) {
      element.products.forEach((e) {
        productList.add(e);
      });
    });

    productList.forEach((element) async {
      await _db.insertDB(
          "Products",
          '(id,productName,productDescription,price,hot,popular,processDuration,mainImage,categoryId)',
          [
            element.id,
            "'${element.productName}'",
            "'${element.productDescription}'",
            "'${element.price}'",
            "'${element.hot}'",
            "'${element.popular.toString()}'",
            "'${element.processDuration}'",
            "'${element.mainImage}'",
            element.categoryId
          ]);
    });

    // await _db.getTable("Products");
    return Future.value(
      mainPage(
          onAddButtonPressed: onAddButtonPressed,
          onFloatButtonPressed: onFloatButtonPressed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLoaderApp(
        app: MaterialApp(
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
        //'/': (context) => LoginScreen(),
        '/Dashboard': (context) => MainHomeScreen(
              onAddButtonPressed: onAddButtonPressed,
              onFloatButtonPressed: onFloatButtonPressed,
            ),
        '/': (context) {
          return new SplashScreen(
            photoSize: MediaQuery.of(context).size.width * 0.5,
            routeName: '/',
            image: Image.asset(
              "assets/img/logocoffee.jpg",
            ),
            seconds: 2,
            // navigateAfterSeconds: mainPage(
            //     onAddButtonPressed: onAddButtonPressed,
            //     onFloatButtonPressed: onFloatButtonPressed),
            navigateAfterFuture: loadFromFuture(),
          );
        },
        '/Services': (context) => MainServiceScreen(),
        '/Kitchen': (context) => MainKitchenScreen(),
        '/Order': (context) => OrderScreen(),
        '/Cart': (context) => ProductInCartScreen(),
      },
    ));
  }
}
