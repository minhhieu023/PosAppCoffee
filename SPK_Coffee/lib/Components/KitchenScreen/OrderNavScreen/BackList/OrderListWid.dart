import 'package:SPK_Coffee/Components/KitchenScreen/OrderNavScreen/OnCompleteList/CompleteList.dart';
import 'package:SPK_Coffee/Components/KitchenScreen/OrderNavScreen/OnProcessList/ProcessList.dart';
import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/Models/OrderDetail.dart';
import 'package:SPK_Coffee/Models/OrderList.dart';
import 'package:SPK_Coffee/Services/DataBaseManagement.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:SPK_Coffee/Services/SocketManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:screen_loader/screen_loader.dart';

import 'OrderDetail.dart';
import 'OrderItem.dart';

GlobalKey<_OrderListWidState> orderListWid = GlobalKey();

class OrderListWid extends StatefulWidget {
  OrderListWid({Key key}) : super(key: key);
  @override
  _OrderListWidState createState() => _OrderListWidState();
}

class _OrderListWidState extends State<OrderListWid>
    with ScreenLoader<OrderListWid> {
  Future<OrderList> orderList;
  Future<OrderList> filterList;
  DataBaseManagement _db = DataBaseManagement();
  int _currentTab = 0;
  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  loader() {
    return AlertDialog(
      title: Text('Wait.. Loading data..'),
    );
  }

  setStateIfMounted(f) {
    if (mounted) {
      setState(f);
    }
  }

  getOrders() {
    this.performFuture(() {
      setStateIfMounted(() {
        orderList = ServiceManager().getAllOrders();
        filterList = orderList;
      });
      orderList.then((value) async {
        await _db.initDB();
        value.data.forEach((element) {
          _db.saveOrderTables(element);
        });
      });
      return orderList;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    //this is socket
    SocketManagement().addListener(
      "getUpdateOrderScreen",
      extensionFunc: getOrders,
    );
  }

  void searchOrder(String id) async {
    // print("run!");
    List<Order> list = await filterList.then(
        (value) => value.data.where((element) => element.id == id).toList());

    setState(() {
      filterList.then((value) {
        value.data = list;
      });
    });
  }

  void resetSearch() async {
    filterList = ServiceManager().getAllOrders();
  }

  void getTabIndex(int tab) {
    _currentTab = tab;
  }

  updateOrder(String orderId) async {
    await this.performFuture(() {
      setState(() {
        orderList = ServiceManager()
            .updateOrder(orderId, _currentTab == 0 ? "processing" : "ready");
        filterList = orderList;
      });
      return orderList;
    });
    SocketManagement().makeMessage("makeUpdateOrderScreen");
  }

  updateOrderByState(String orderId, String stateToChange) async {
    await this.performFuture(() {
      setState(() {
        orderList = ServiceManager().updateOrder(orderId, stateToChange);
        filterList = orderList;
      });
      return orderList;
    });
    SocketManagement().makeMessage("makeUpdateOrderScreen");
  }

  void getRemoveItem(Order order) {
    updateOrder(order.id);
  }

  void onClickOrder(
      List<OrderDetail> orderDetail, List<ProductsInfo> productsInfo) {
    //pass list for each order
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(45),
                  topRight: const Radius.circular(45))),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              Title(
                color: Colors.green,
                child: Text(
                  "Order number: ${orderDetail[0].orderId}",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: orderDetail.length,
                itemBuilder: (context, index) {
                  return OrderDetailWid(
                    detail: orderDetail[index],
                    productsInfo: productsInfo,
                  );
                },
              ))
            ],
          ),
        );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {

  // }

  @override
  Widget screen(BuildContext context) {
    // TODO: implement screen
    return FutureBuilder<OrderList>(
      future: filterList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scrollbar(
              thickness: 15,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    // decoration: BoxDecoration(
                    //     border: Border.all(width: 0.5, color: Colors.black)),
                    //put orderlist to list
                    child: TopItems(
                      snapshot.data,
                      popDetails: onClickOrder,
                      getRemoveItem: getRemoveItem,
                    ),
                    height: (MediaQuery.of(context).size.height * 0.4) - 56,
                    width: (MediaQuery.of(context).size.width * 0.8) - 0.5,
                  ),
                  Expanded(
                      child: Container(
                    width: MediaQuery.of(context).size.width - 0.5,
                    child: BottomItem(
                      getTabIndex: getTabIndex,
                      orderList: snapshot.data,
                      updateOrderState: updateOrderByState,
                    ),
                  ))
                ],
              ));
        }
        return SpinKitCircle(
          color: Colors.green,
        );
      },
    );
  }
}

class TopItems extends StatefulWidget {
  final OrderList list;
  final Function(Order) getRemoveItem;
  final Function(List<OrderDetail>, List<ProductsInfo>) popDetails;
  TopItems(
    this.list, {
    this.popDetails,
    this.getRemoveItem,
  });
  @override
  _TopItemsState createState() => _TopItemsState();
}

class _TopItemsState extends State<TopItems> {
  List<Order> orderList = [];
  @override
  void initState() {
    super.initState();
  }

  void filterList() {
    orderList.clear();
    widget.list.data.forEach((item) {
      if (item.state == "open") {
        orderList.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //filter list  get all order with state = "open".
    filterList();
    return GridView.builder(
      itemCount: orderList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return OrderItem(
          details: orderList[index],
          orderTable: widget.list.tables.length >= index
              ? widget.list.tables[index]
              : null,
          popDetails: widget.popDetails,
          productInfo: widget.list.productsInfo,
          getRemoveItem: widget.getRemoveItem,
        );
      },
    );
  }
}

class BottomItem extends StatefulWidget {
  final Function(int) getTabIndex;
  final OrderList orderList;
  final Function(String, String) updateOrderState;
  BottomItem({this.getTabIndex, this.orderList, this.updateOrderState});
  @override
  _BottomItemState createState() => _BottomItemState();
}

class _BottomItemState extends State<BottomItem> {
  String data = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.orderList.data);
    return Builder(
      builder: (context) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: AppBar(
                automaticallyImplyLeading: false,
                title: TabBar(
                  onTap: (value) {
                    widget.getTabIndex(value);
                  },
                  tabs: [
                    Tab(
                      icon: Icon(Icons.work),
                    ),
                    Tab(
                      icon: Icon(Icons.done_outline),
                    )
                  ],
                ),
              ),
            ),
            body: TabBarView(children: [
              ProcessListWid(
                list: widget.orderList,
                updateOrderState: widget.updateOrderState,
              ),
              CompleteListWid(
                list: widget.orderList,
                updateOrderState: widget.updateOrderState,
              )
            ]),
          ),
        );
      },
    );
  }
}
