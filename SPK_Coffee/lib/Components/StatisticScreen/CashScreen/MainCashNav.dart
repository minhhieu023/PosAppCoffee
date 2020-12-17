import 'package:SPK_Coffee/Components/StatisticScreen/CashScreen/CalculatePadWid.dart';
import 'package:SPK_Coffee/Components/StatisticScreen/CashScreen/PaymentList/PendingPayment.dart';
import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/Models/OrderList.dart';
import 'package:SPK_Coffee/Models/ProviderModels/Calculate.dart';
import 'package:SPK_Coffee/Models/ProviderModels/CashScreenProvider.dart';
import 'package:SPK_Coffee/Models/ProviderModels/VoucherProvider.dart';
import 'package:SPK_Coffee/Models/Voucher.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:SPK_Coffee/Utils/UtilitiesFunc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainCashNav extends StatefulWidget {
  final Future<OrderList> orderList;
  final Function() getReadyOrders;
  MainCashNav({this.orderList, this.getReadyOrders});
  @override
  _MainCashNavState createState() => _MainCashNavState();
}

class _MainCashNavState extends State<MainCashNav> {
  Future<OrderList> list;
  List<Order> orders = [];
  Screen screen = new Screen();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = widget.orderList;
    // setup();
  }

  void setup() {
    if (list != null) {
      list = widget.orderList;
    }
  }

  void getOrders(List<Order> orderList) {
    orders.clear();
    orderList.forEach((order) {
      orders.add(order);
    });
  }

  @override
  Widget build(BuildContext context) {
    setup();
    return FutureBuilder<OrderList>(
      future: list,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          getOrders(snapshot.data.data);
          if (MediaQuery.of(context).orientation == Orientation.landscape) {
            return LandScapeCashScreen(
              orderList: snapshot.data,
              orders: orders,
              getReadyOrders: widget.getReadyOrders,
            );
          } else {
            return Center(
              child: Text("We are working on this!"),
            );
          }
        } else {
          return CircularProgressIndicator(
            backgroundColor: Colors.green,
          );
        }
      },
    );
  }
}

class LandScapeCashScreen extends StatefulWidget {
  final Future<VoucherList> fVoucher;
  final OrderList orderList;
  final List<Order> orders;
  final Function() getReadyOrders;
  LandScapeCashScreen(
      {this.orderList, this.orders, this.fVoucher, this.getReadyOrders});
  @override
  _LandScapeCashScreenState createState() => _LandScapeCashScreenState();
}

class _LandScapeCashScreenState extends State<LandScapeCashScreen> {
  Future<VoucherList> fvoucher;
  void getVoucherList() {
    setState(() {
      fvoucher = ServiceManager().getAllVoucher();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVoucherList();
  }

  @override
  Widget build(BuildContext context) {
    // getVoucherList();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Calculate()),
        ChangeNotifierProvider(create: (context) => CashProvider()),
        ChangeNotifierProvider(create: (context) {
          return VoucherProvider(fvoucher);
        })
      ],
      child: Row(
        children: [
          Expanded(
              child: CalculatePadWid(
            getReadyOrders: widget.getReadyOrders,
          )),
          Expanded(
              child: PendingListWid(
            orderList: widget.orderList,
          )),
        ],
      ),
    );
  }
}
