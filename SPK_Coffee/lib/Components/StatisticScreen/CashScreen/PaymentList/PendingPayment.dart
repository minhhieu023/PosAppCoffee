import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/Models/OrderList.dart';
import 'package:SPK_Coffee/Models/ProviderModels/Calculate.dart';
import 'package:SPK_Coffee/Models/ProviderModels/CashScreenProvider.dart';
import 'package:SPK_Coffee/Models/ProviderModels/UserProvider.dart';
import 'package:SPK_Coffee/Models/ProviderModels/VoucherProvider.dart';
import 'package:SPK_Coffee/Models/Shippers.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:SPK_Coffee/Services/SocketManager.dart';
import 'package:SPK_Coffee/Utils/Dictonary.dart';
import 'package:SPK_Coffee/Utils/FormatString.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:screen_loader/screen_loader.dart';

class PendingListWid extends StatefulWidget {
  final OrderList orderList;
  final OrderList historyOrder;
  final Function() getVoucherList;
  PendingListWid({this.orderList, this.historyOrder, this.getVoucherList});
  @override
  _PendingListWidState createState() => _PendingListWidState();
}

class _PendingListWidState extends State<PendingListWid> {
  int currentTab = 0;
  OrderList historyList;
  OrderList orderList;
  // Widget displayTab() {
  //   return ;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void getOrderList() {
    if (widget.orderList != null) {
      orderList = widget.orderList;
    }
    if (widget.historyOrder != null) {
      historyList = widget.historyOrder;
    }
  }

  @override
  Widget build(BuildContext context) {
    getOrderList();
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              height: kToolbarHeight,
              child: Column(
                children: [
                  TabBar(
                    overlayColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    labelColor: Colors.black,
                    onTap: (value) {
                      setState(() {
                        currentTab = value;
                      });
                    },
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: new BubbleTabIndicator(
                      indicatorHeight: 25,
                      indicatorColor: Colors.blueAccent,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                    tabs: [
                      Tab(
                        text: "Pending",
                      ),
                      Tab(
                        text: "Paid",
                      )
                    ],
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                  )
                ],
              ),
            ),
          ),
          body: currentTab == 0
              ? new CashOrdersWid(
                  orderList: orderList,
                  type: "pending",
                )
              : new CashOrdersWid(
                  orderList: historyList,
                  type: "closed",
                ),
        ));
  }
}

class CashOrdersWid extends StatefulWidget {
  final OrderList orderList;
  final String type;
  CashOrdersWid({this.orderList, this.type});
  @override
  _CashOrdersWidState createState() => _CashOrdersWidState();
}

class _CashOrdersWidState extends State<CashOrdersWid>
    with ScreenLoader<CashOrdersWid> {
  OrderList orderList;
  List<Order> filterList = [];
  List<OrderTable> orderTable = [];
  List<ProductsInfo> productsInfo = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<dynamic> filterOrders() {
    List<Order> tempList = [];
    List<OrderTable> tables = [];
    List<ProductsInfo> infors = [];
    for (var i = 0; i < orderList.data.length; i++) {
      if (widget.type == "pending") {
        if (orderList.data[i].state == "ready") {
          tempList.add(orderList.data[i]);
          tables.add(orderList.tables[i]);
        }
      }
      if (widget.type == "closed") {
        if (orderList.data[i].state == "closed") {
          tempList.add(orderList.data[i]);
          // tables.add(orderList.tables[i]);
        }
      }
    }
    orderList.productsInfo.forEach((element) {
      infors.add(element);
    });
    return [tempList, tables, infors];
  }

  void getOrder() {
    if (widget.orderList != null) {
      orderList = widget.orderList;
    }
  }

  @override
  Widget screen(BuildContext context) {
    Calculate calculate = Provider.of<Calculate>(context);
    CashProvider cashProvider = Provider.of<CashProvider>(context);
    UserProvider user = Provider.of<UserProvider>(context);
    getOrder();
    List<dynamic> allInfo = filterOrders();
    List<Order> orders = allInfo[0];
    List<OrderTable> tables = allInfo[1];
    List<ProductsInfo> infors = allInfo[2];
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(top: 5, left: 5, right: 5),
          decoration: BoxDecoration(
              border: Border.all(width: 0.5),
              borderRadius: BorderRadius.circular(30)),
          child: ListTile(
            leading: CircleAvatar(
              child: Image.asset(
                "assets/img/bill.png",
                width: 50,
                height: 50,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onTap: () {
              cashProvider.setCurrentOrder(orders[index]);
              cashProvider.setProductsInfo(infors);
              calculate.setFirstNumber(double.parse(orders[index].total));
              cashProvider.calulateTotal();
              calculate.setIsSecond(true);
            },
            title: widget.type != "closed"
                ? (tables[index] == null
                    ? (Text("Remote Order"))
                    : tables[index] != null
                        ? (widget.type != "closed"
                            ? (tables[index].tablename != null
                                ? Text("TABLE ${tables[index].tablename}")
                                : Text("Remote Order"))
                            : Text("TABLE ${orders[index].tableName}"))
                        : Text("Remote Order ${orders[index].endUserId}"))
                : Text("History Order"),
            subtitle: Text(
                "Order number:${orders[index].id} \n Amount of money: ${formatMoney(orders[index].total.split('.')[0])} VNĐ"),
            isThreeLine: true,
            trailing: orders[index].isShipper != null
                ? IconButton(
                    icon: Icon(Icons.more),
                    onPressed: () async {
                      List<Shippers> shipper;
                      // fetch shipper info
                      if (user.shipper == null || user.shipper.length <= 0) {
                        shipper = await this.performFuture(() async {
                          return await ServiceManager()
                              .getShipper(orders[index].isShipper);
                        });
                      }
                      if (shipper != null) {
                        user.setShipper(shipper);
                      }
                      await NDialog(
                        dialogStyle: DialogStyle(titleDivider: true),
                        title: Text(
                          "Shipper Information",
                          textAlign: TextAlign.center,
                        ),
                        content: showShipperInfomation(
                            context,
                            user.shipper
                                .where((item) =>
                                    item.id == orders[index].isShipper)
                                .first),
                        actions: [
                          TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )))
                        ],
                      ).show(context);
                    })
                : null,
          ),
        );
      },
    );
  }
}

Widget showShipperInfomation(BuildContext context, Shippers shipper) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.7,
    height: MediaQuery.of(context).size.height * 0.6,
    child: ListView(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
          alignment: Alignment.center,
          child: Image.network(
            "${staticPath['sock']}/uploads/${shipper.avt}",
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.4,
            errorBuilder: (context, object, stackTrace) {
              return Image.asset("assets/img/man.png");
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Name: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(shipper.name, overflow: TextOverflow.ellipsis)
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Age: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(shipper.age, overflow: TextOverflow.ellipsis)
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Phone number: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(shipper.phoneNumber, overflow: TextOverflow.ellipsis)
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Info: ",
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
              ),
              Text(
                shipper.shipperInfo,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ],
    ),
  );
}
