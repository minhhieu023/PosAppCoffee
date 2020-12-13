import 'package:SPK_Coffee/Components/ServiceScreen/PaymentScreen.dart';
import 'package:SPK_Coffee/Models/Category.dart';
import 'package:SPK_Coffee/Models/CoffeeTable.dart';
import 'package:SPK_Coffee/Models/Product.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:SPK_Coffee/Utils/StaticValue.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProductComponent.dart';
import 'ProductInCartScreen.dart';

class OrderScreen extends StatefulWidget {
  final CoffeeTable table;
  final Function setStateWhenHaveOrder;

  OrderScreen({
    this.table,
    this.setStateWhenHaveOrder,
    Key key,
  }) : super(key: key);
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  //
  bool isUpdateInCart = false;
  Future<Category> futureGetCategory;
  Future<ListProduct> listProductJson;
  TabController tabController;
  List<Products> listProduct = new List<Products>();
  bool haveOrder = false;
  bool isOpenCart = false;
  //ListProduct listProductJson;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isEmpty = true;
  bool isAddMoreProduct;
  void addOrderedProduct(Products product) {
    print(listProduct.toList());
    //Nếu amount = 0 thì xoá khỏi list
    if (product.amount == 0) {
      listProduct.remove(product);
      return;
    }
    //nếu không có sản phẩm nào thì thêm vào
    if (listProduct.length == 0) {
      listProduct.add(product);
      return;
    } else {
      if (!listProduct.contains(product)) {
        listProduct.add(product);
        return;
      }
    }
  }

  int counter = 0;
  ServiceManager serviceManager;
  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      counter--;
    });
  }

  void updateAmountProduct() {
    setState(() {
      counter = 0;
      isUpdateInCart = true;
      listProduct.removeWhere((element) => element.amount == 0);
      listProduct.forEach((element) {
        counter += element.amount;
      });
    });
    isUpdateInCart = true;

    print(counter);
  }

  @override
  void initState() {
    super.initState();

    serviceManager = ServiceManager();
    futureGetCategory = serviceManager.getProductWithCategory();
    isAddMoreProduct = false;
    tabController = new TabController(vsync: this, length: 2);
    print(futureGetCategory.toString());
  }

  @override
  Widget build(BuildContext context) {
    OrderScreen args = ModalRoute.of(context).settings.arguments;
    if (args.table.isEmpty == false) {
      listProductJson =
          serviceManager.getOrderByTableId(args.table.id.toString());
      haveOrder = true;
    }
    return FutureBuilder<Category>(
        future: futureGetCategory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return Scaffold(
              appBar: AppBar(
                title: Text("${args.table.name}-${args.table.id}-Order"),
              ),
              body: haveOrder == false
                  ? Column(
                      children: [
                        Container(
                          child: TabBar(
                            key: Key("Drink"),
                            controller: tabController,
                            tabs: snapshot.data.data.map((e) {
                              print(e.name);
                              return Container(
                                width: MediaQuery.of(context).size.width /
                                        (snapshot.data.data.length) -
                                    40,
                                child: Tab(
                                  child: Text(
                                    "${e.name}",
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                              );
                            }).toList(),
                            unselectedLabelColor: Colors.black,
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: new BubbleTabIndicator(
                              indicatorHeight: 30.0,
                              indicatorColor: Colors.blueAccent,
                              tabBarIndicatorSize: TabBarIndicatorSize.tab,
                            ),
                          ),
                        ),
                        Container(
                          height: (MediaQuery.of(context).size.height -
                                  kToolbarHeight) *
                              0.89,
                          child: TabBarView(
                            controller: tabController,
                            children: snapshot.data.data.map(
                              (e) {
                                {
                                  final orientation =
                                      MediaQuery.of(context).orientation;
                                  return GridView.builder(
                                    gridDelegate:
                                        new SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: (orientation ==
                                                    Orientation.portrait)
                                                ? 2
                                                : 3),
                                    itemCount: e.products.length,
                                    padding: EdgeInsets.all(10),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ProductComponent(
                                        products: e.products[index],
                                        incrementCounter: _incrementCounter,
                                        decrementCounter: _decrementCounter,
                                        addProductToCart: addOrderedProduct,
                                        isUpdateInCart: isUpdateInCart,
                                      );
                                    },
                                  );
                                }
                              },
                            ).toList(),
                          ),
                        ),
                      ],
                    )
                  : isAddMoreProduct
                      ? Column(
                          children: [
                            Container(
                              child: TabBar(
                                key: Key("Drink"),
                                controller: tabController,
                                tabs: snapshot.data.data.map((e) {
                                  print(e.name);
                                  return Container(
                                    width: MediaQuery.of(context).size.width /
                                            (snapshot.data.data.length) -
                                        40,
                                    child: Tab(
                                      child: Text(
                                        "${e.name}",
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                unselectedLabelColor: Colors.black,
                                isScrollable: true,
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicator: new BubbleTabIndicator(
                                  indicatorHeight: 30.0,
                                  indicatorColor: Colors.blueAccent,
                                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                                ),
                              ),
                            ),
                            Container(
                              height: (MediaQuery.of(context).size.height -
                                      kToolbarHeight) *
                                  0.89,
                              child: TabBarView(
                                controller: tabController,
                                children: snapshot.data.data.map(
                                  (e) {
                                    {
                                      final orientation =
                                          MediaQuery.of(context).orientation;
                                      return GridView.builder(
                                        gridDelegate:
                                            new SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: (orientation ==
                                                        Orientation.portrait)
                                                    ? 2
                                                    : 3),
                                        itemCount: e.products.length,
                                        padding: EdgeInsets.all(10),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ProductComponent(
                                            products: e.products[index],
                                            incrementCounter: _incrementCounter,
                                            decrementCounter: _decrementCounter,
                                            addProductToCart: addOrderedProduct,
                                            isUpdateInCart: isUpdateInCart,
                                          );
                                        },
                                      );
                                    }
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        )
                      : FutureBuilder<ListProduct>(
                          future: listProductJson,
                          builder: (context, snapshopHaveOrder) {
                            if (snapshopHaveOrder.hasData) {
                              listProduct = snapshopHaveOrder.data.listProduct;
                              print(listProduct[0].id);
                              return ProductInCartScreen(
                                listProduct: listProduct,
                                haveOrder: true,
                              );
                            } else {
                              return ProductInCartScreen(
                                listProduct: listProduct,
                                haveOrder: false,
                              );
                            }
                          }),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  isAddMoreProduct == false && haveOrder == true
                      ? FloatingActionButton(
                          heroTag: "btn1",
                          child: FaIcon(FontAwesomeIcons.plus),
                          backgroundColor: Colors.red,
                          onPressed: () {
                            setState(() {
                              isAddMoreProduct == true
                                  ? isAddMoreProduct = false
                                  : isAddMoreProduct = true;
                            });
                          })
                      : Container(),
                  SizedBox(height: 10),
                  haveOrder == false
                      ? FloatingActionButton(
                          heroTag: "btn2",
                          onPressed: () {
                            showMaterialModalBottomSheet(
                              context: context,
                              builder: (context) => ProductInCartScreen(
                                listProduct: listProduct,
                                addProductToCart: updateAmountProduct,
                                haveOrder: false,
                              ),
                            );
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => ProductInCartScreen(
                            //             listProduct: listProduct,
                            //             addProductToCart: updateAmountProduct,
                            //             haveOrder: false,
                            //           )),
                            // );
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart),
                                Text(counter.toString(),
                                    style: TextStyle(fontSize: 20)),
                              ]),
                          backgroundColor: Colors.blue,
                        )
                      : isAddMoreProduct
                          ? FloatingActionButton(
                              heroTag: "btn2",
                              onPressed: () {
                                showMaterialModalBottomSheet(
                                  context: context,
                                  builder: (context) => ProductInCartScreen(
                                    listProduct: listProduct,
                                    addProductToCart: updateAmountProduct,
                                    haveOrder: false,
                                  ),
                                );
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => ProductInCartScreen(
                                //             listProduct: listProduct,
                                //             addProductToCart: updateAmountProduct,
                                //             haveOrder: false,
                                //           )),
                                // );
                              },
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.shopping_cart),
                                    Text(counter.toString(),
                                        style: TextStyle(fontSize: 20)),
                                  ]),
                              backgroundColor: Colors.blue,
                            )
                          : Container(),
                  listProduct.isNotEmpty
                      ? Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: RaisedButton(
                                  color: Colors.pinkAccent,
                                  onPressed: () async {
                                    SharedPreferences prefs = await _prefs;
                                    await createOrder(
                                        listProduct,
                                        prefs.getString("role"),
                                        'open',
                                        (args.table.id).toString(),
                                        "0");
                                    print("Lưu");
                                    args.setStateWhenHaveOrder.call();
                                    Navigator.pop(context);
                                  },
                                  child: Text("Save"),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.01),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: RaisedButton(
                                  color: Colors.amberAccent,
                                  onPressed: () {
                                    print("thanh toán");
                                  },
                                  child: Text(
                                    "Notify Casher",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                ],
              ),
            );
          } else
            return Scaffold(
              appBar: AppBar(
                title: Text("Order"),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        });
  }
}

Future<void> createOrder(List<Products> listProduct, String employeeId,
    String state, String tableId, String discount) async {
  ServiceManager serviceManager = new ServiceManager();
  // List<OrderDetail> listOrderdetail;
  // listProduct.forEach((element) {
  //   OrderDetail orderDetail = new OrderDetail(
  //       productId: element.id,
  //       amount: element.amount,
  //       price: (int.parse(element.price) * element.amount).toString());
  //   listOrderdetail.add(orderDetail);
  // });
  listProduct.forEach((element) {
    element.productId = element.id;
    element.price = (int.parse(element.price) * element.amount).toString();
  });
  await serviceManager.createOrder(
      listProduct, employeeId, state, tableId, discount);
}
