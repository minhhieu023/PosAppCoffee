import 'package:SPK_Coffee/Components/StatisticScreen/CashScreen/MainCashNav.dart';
import 'package:SPK_Coffee/Components/StatisticScreen/Statistic/MainStatisticNav.dart';
import 'package:SPK_Coffee/Models/OrderList.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:screen_loader/screen_loader.dart';

class MainStatisticsScreen extends StatefulWidget {
  @override
  _MainStatisticsScreenState createState() => _MainStatisticsScreenState();
}

class _MainStatisticsScreenState extends State<MainStatisticsScreen>
    with SingleTickerProviderStateMixin, ScreenLoader<MainStatisticsScreen> {
  bool initFloattingBtn = true;
  int currentTitle = 0;
  OrderList orderList;
  Animation<double> _animation;
  AnimationController _animationController;
  bool isPressed = true;
  Widget _page = MainCashNav();
  void getReadyOrders() async {
    await this.performFuture(() async {
      orderList = await ServiceManager().getReadyOrders();
      print(orderList);
      return orderList;
    });
    // setState(() {
    //   orderList = await ServiceManager().getReadyOrders();
    // });
  }

  getFullOrder() async {
    await this.performFuture(() async {
      orderList = await ServiceManager().getAllOrders();
      return orderList;
    });
  }

  @override
  loader() {
    return AlertDialog(
      title: Text('Wait.. Loading data..'),
    );
  }

  @override
  void initState() {
    getReadyOrders();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          currentTitle = 0;
          _page = Visibility(
              child: MainCashNav(
            orderList: orderList,
          ));
          break;
        case 1:
          currentTitle = 1;
          _page = Visibility(child: MainStatisticsNav());
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

  void navTapped(int index) {
    _handleNavigationChange(index);
    _animationController.reverse();
    setState(() {
      isPressed = false;
    });
  }

  // @override
  // Widget build(BuildContext context) {

  // }

  @override
  Widget screen(BuildContext context) {
    // TODO: implement screen
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionBubble(
        animation: _animation,
        onPress: () {
          setState(() {
            if (initFloattingBtn) {
              initFloattingBtn = false;
            }
          });
          if (_animationController.isCompleted) {
            setState(() {
              isPressed = false;
            });
            //close nav
            _animationController.reverse();
          } else {
            setState(() {
              isPressed = true;
            });
            //open nav
            _animationController.forward();
          }
        },
        iconColor: Colors.white,
        iconData: initFloattingBtn
            ? Icons.add
            : (isPressed ? Icons.close : Icons.add),
        backGroundColor: Colors.blue,
        items: <Bubble>[
          Bubble(
            title: "Cashier",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.attach_money,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              navTapped(0);
            },
          ),
          Bubble(
            title: "Statistics",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.bar_chart,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              navTapped(1);
            },
          ),
        ],
      ),
      body: _page,
    );
  }
}
