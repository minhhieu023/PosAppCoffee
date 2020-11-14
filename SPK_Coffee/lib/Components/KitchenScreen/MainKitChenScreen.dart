import 'package:SPK_Coffee/Components/KitchenScreen/DishList.dart';
import 'package:SPK_Coffee/Components/KitchenScreen/BackList/OrderListWid.dart';
import 'package:flutter/material.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';

class MainKitchenScreen extends StatefulWidget {
  @override
  _MainKitchenScreenState createState() => _MainKitchenScreenState();
}

class _MainKitchenScreenState extends State<MainKitchenScreen> {
  // init is order page
  List<String> titles = ["Orders", "Dishes"];
  int currentTitle = 0;
  Widget _page = OrderListWid();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(titles[currentTitle]),
        ),
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

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          currentTitle = 0;
          _page = OrderListWid();
          break;
        case 1:
          currentTitle = 1;
          _page = DishList();
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
}
