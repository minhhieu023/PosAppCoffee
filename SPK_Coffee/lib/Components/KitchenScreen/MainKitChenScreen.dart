import 'package:SPK_Coffee/Components/KitchenScreen/DishNavScreen/DishList.dart';
import 'package:SPK_Coffee/Components/KitchenScreen/DishNavScreen/Sorts/SortByDuration.dart';
import 'package:SPK_Coffee/Models/OrderList.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:flutter/material.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:screen_loader/screen_loader.dart';

import 'OrderNavScreen/BackList/OrderListWid.dart';

class MainKitchenScreen extends StatefulWidget {
  @override
  _MainKitchenScreenState createState() => _MainKitchenScreenState();
}

class _MainKitchenScreenState extends State<MainKitchenScreen>
    with ScreenLoader<MainKitchenScreen> {
  // init is order page
  List<String> titles = ["Orders", "Dishes"];
  bool isSearch = false;
  bool sortMode = false;
  int currentTitle = 0;
  int currPage = 0;
  OrderList orderList;
  Widget _page = OrderListWid(
    key: orderListWid,
  );
  Function() getSortScreen(Function childFunc) {
    return childFunc;
  }

  @override
  loader() {
    return AlertDialog(
      title: Text('Wait.. Loading data..'),
    );
  }

  getFullOrder() async {
    await this.performFuture(() async {
      orderList = await ServiceManager().getAllOrders();
      return orderList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFullOrder();
  }

  Widget searchBox() {
    return TextField(
      autofocus: true,
      maxLength: 9,
      onChanged: (value) {
        print(value);
        orderListWid.currentState.searchOrder(value);
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {}

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          currentTitle = 0;
          _page = Visibility(
              child: OrderListWid(
            key: orderListWid,
          ));
          break;
        case 1:
          currentTitle = 1;
          _page = Visibility(
              child: DishList(
            getSortScreen: getSortScreen,
          ));
          break;
      }
      _page = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 250),
        child: _page,
      );
    });
  }

  @override
  Widget screen(BuildContext context) {
    // TODO: implement screen
    return Scaffold(
        appBar: currentTitle == 0
            ? AppBar(
                automaticallyImplyLeading: isSearch ? false : true,
                title: !isSearch ? Text(titles[currentTitle]) : searchBox(),
                actions: currentTitle == 0
                    ? [
                        !isSearch
                            ? IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  setState(() {
                                    isSearch = true;
                                  });
                                })
                            : IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    isSearch = false;
                                    // orderListWid.currentState.getOrders();
                                    orderListWid.currentState.resetSearch();
                                  });
                                }),
                      ]
                    : [
                        IconButton(
                            icon: Icon(Icons.sort),
                            onPressed: () {
                              // setState(() {
                              //   sortMode = true;
                              // });
                            })
                      ],
              )
            : null,
        floatingActionButton: null,
        bottomNavigationBar: SizedBox(
          height: 56,
          child: FluidNavBar(
            animationFactor: 0.3,
            style: FluidNavBarStyle(barBackgroundColor: Colors.pink),
            icons: [
              FluidNavBarIcon(
                  iconPath: "assets/img/receipt.svg",
                  unselectedForegroundColor: Colors.white,
                  backgroundColor: Color.fromRGBO(74, 186, 83, 1)),
              FluidNavBarIcon(
                  iconPath: "assets/img/poke.svg",
                  unselectedForegroundColor: Colors.white,
                  backgroundColor: Color.fromRGBO(240, 191, 3, 1))
            ],
            onChange: _handleNavigationChange,
          ),
        ),
        body: _page);
  }
}
