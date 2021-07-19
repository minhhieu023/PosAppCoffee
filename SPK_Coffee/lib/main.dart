import 'dart:io';
import 'package:SPK_Coffee/Components/HomeScreen/MainHomeScreen.dart';
import 'package:SPK_Coffee/Components/KitchenScreen/MainKitChenScreen.dart';
import 'package:SPK_Coffee/Components/LoginScreen/LoginScreen.dart';
import 'package:SPK_Coffee/Components/Manage/ManageUserScreen.dart';
import 'package:SPK_Coffee/Components/Shipment/Shipment.dart';
import 'package:SPK_Coffee/Components/StatisticScreen/MainStatisticsScreen.dart';
import 'package:SPK_Coffee/Models/Category.dart';
import 'package:SPK_Coffee/Models/Product.dart';
import 'package:SPK_Coffee/Services/DataBaseManagement.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:SPK_Coffee/Utils/StaticValue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_loader/screen_loader.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dcdg/dcdg.dart';
// import 'Utils/Config.dart';
import 'Components/ServiceScreen/AreaScreen/AreaScreen.dart';
import 'Components/ServiceScreen/OrderScreen/OrderScreen.dart';
import 'Components/ServiceScreen/OrderScreen/ProductInCartScreen.dart';
import 'Components/Settings/Settings.dart';
import 'Components/StatisticScreen/CashScreen/MainCashNav.dart';
import 'Components/StatisticScreen/Statistic/MainStatisticNav.dart';
import 'Models/ProviderModels/UserProvider.dart';
import 'Services/SocketManager.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

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
  runApp(Phoenix(child: MyApp()));
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
  Color mainColor;
  @override
  void initState() {
    super.initState();
    // _socketManagement.createSocketConnection();
    getColor();
  }

  Future<void> getColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("appColor"));
    setState(() {
      mainColor = prefs.getString("appColor") != null
          ? Color(int.parse(prefs.getString("appColor")))
          : mPrimaryColor;
    });
  }

  void onFloatButtonPressed() {
    _socketManagement.socket
        .emit('send notification', 'HIHIHIH table have customer!');
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
    if (futureGetCategory.data != null) {
      futureGetCategory.data.forEach((element) {
        element.products.forEach((e) {
          productList.add(e);
        });
      });
    }

    // productList.forEach((element) async {
    //   await _db.insertDB(
    //       "Products",
    //       '(id,productName,productDescription,price,hot,popular,processDuration,mainImage,categoryId)',
    //       [
    //         element.id,
    //         "'${element.productName}'",
    //         "'${element.productDescription}'",
    //         "'${element.price}'",
    //         "'${element.hot}'",
    //         "'${element.popular.toString()}'",
    //         "'${element.processDuration}'",
    //         "'${element.mainImage}'",
    //         element.categoryId
    //       ]);
    // });

    await _db.getTable("Products");
    return Future.value(
      LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: ScreenLoaderApp(
          app: MaterialApp(
        color: mainColor == null ? mPrimaryColor : mainColor,
        theme: new ThemeData(
          primaryColor: mainColor == null ? mPrimaryColor : mainColor,
          backgroundColor: mainColor == null ? mPrimaryColor : mainColor,
          shadowColor: Colors.black12,
          brightness: Brightness.light,
          // primaryColor: Colors.white,
          //accentColor: Colors.blueAccent,
        ),
        // theme: ThemeData(primaryColor: Colors.blue[100]),
        initialRoute: '/',
        routes: {
          '/Login': (context) => LoginScreen(),
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
          '/Payment': (context) => MainStatisticsScreen(),
          '/Statistics': (context) => MainStatisticsNav(),
          '/Setting': (context) => Settings(),
          '/shipment': (context) => Shipment(),
        },
      )),
    );
  }
}
