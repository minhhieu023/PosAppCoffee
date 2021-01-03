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
  List<Order> sub;
  List<Order> filterSub = [];
  Future<OrderList> filterList;
  Map<String, dynamic> object;
  DataBaseManagement _db = DataBaseManagement();
  bool isSearch = false;
  int _currentTab = 0;
  bool isUpdate = false;
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

  getOrders() async {
    this.performFuture(() {
      setStateIfMounted(() {
        orderList = ServiceManager().getAllOrders();
        filterList = orderList;
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

  void searchOrder(String id) {
    List<Order> tempSearch = [];
    if (id.isEmpty) {
      setState(() {
        filterSub = sub;
      });
      return;
    }
    sub.forEach((element) {
      if (element.id.contains(id)) {
        tempSearch.add(element);
      }
    });
    setState(() {
      isSearch = true;
      filterSub = tempSearch;
    });
    // print(filterList);
  }

  void resetSearch() {
    setState(() {
      isSearch = false;
      filterSub = sub;
    });
  }

  void getTabIndex(int tab) {
    _currentTab = tab;
  }

  updateOrder(String orderId) async {
    await this.performFuture(() {
      setState(() {
        orderList = ServiceManager()
            .updateOrder(orderId, _currentTab == 0 ? "processing" : "ready");
        isUpdate = true;
      });
      return orderList;
    });
    SocketManagement().makeMessage("makeUpdateOrderScreen");
    if (_currentTab == 1) {
      SocketManagement().makeMessage("getUpdateAllKitchen");
    }
  }

  updateOrderByState(String orderId, String stateToChange) async {
    await this.performFuture(() {
      setState(() {
        orderList = ServiceManager().updateOrder(orderId, stateToChange);
        filterList = orderList;
        isUpdate = true;
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
      future: orderList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // object = snapshot.data.saveJson;
          sub = snapshot.data.data;
          filterSub = !isSearch ? sub : filterSub;
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
                      orders: filterSub,
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
                      orders: filterSub,
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
  final List<Order> orders;
  final Function(Order) getRemoveItem;
  final Function(List<OrderDetail>, List<ProductsInfo>) popDetails;
  TopItems(this.list, {this.popDetails, this.getRemoveItem, this.orders});
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
    widget.orders.forEach((item) {
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
  final List<Order> orders;
  final Function(String, String) updateOrderState;
  BottomItem(
      {this.getTabIndex, this.orderList, this.updateOrderState, this.orders});
  @override
  _BottomItemState createState() => _BottomItemState();
}

class _BottomItemState extends State<BottomItem> {
  String data = "";
  List<Order> orders = [];
  @override
  void initState() {
    super.initState();
  }

  updateList() {
    orders = widget.orders;
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.orderList.data);
    updateList();

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
                      text: "Processing",
                    ),
                    Tab(
                      text: "Ready",
                    )
                  ],
                ),
              ),
            ),
            body: TabBarView(children: [
              ProcessListWid(
                list: widget.orderList,
                updateOrderState: widget.updateOrderState,
                orders: orders,
              ),
              CompleteListWid(
                list: widget.orderList,
                updateOrderState: widget.updateOrderState,
                orders: orders,
              )
            ]),
          ),
        );
      },
    );
  }
}
