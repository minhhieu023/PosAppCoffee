import 'package:SPK_Coffee/Components/ServiceScreen/ProductInCartScreen.dart';
import 'package:SPK_Coffee/Models/Category.dart';
import 'package:SPK_Coffee/Models/CoffeeTable.dart';
import 'package:SPK_Coffee/Models/OrderDetail.dart';
import 'package:SPK_Coffee/Models/Product.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:SPK_Coffee/Utils/Config.dart';
import 'package:SPK_Coffee/Utils/StaticValue.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  final CoffeeTable table;

  OrderScreen({
    this.table,
    Key key,
  }) : super(key: key);
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  bool isUpdateInCart = false;
  Future<Category> futureGetCategory;
  TabController tabController;
  List<Products> listProduct = new List<Products>();
  bool isEmpty = true;

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
    tabController = new TabController(vsync: this, length: 2);
    print(futureGetCategory.toString());
  }

  @override
  Widget build(BuildContext context) {
    final OrderScreen args = ModalRoute.of(context).settings.arguments;
    return FutureBuilder<Category>(
        future: futureGetCategory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return Scaffold(
              appBar: AppBar(
                title: Text("${args.table.name}-Order"),
              ),
              body: Column(
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
                    height:
                        (MediaQuery.of(context).size.height - kToolbarHeight) *
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
                                      crossAxisCount:
                                          (orientation == Orientation.portrait)
                                              ? 2
                                              : 3),
                              itemCount: e.products.length,
                              padding: EdgeInsets.all(10),
                              itemBuilder: (BuildContext context, int index) {
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
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                      heroTag: "btn1",
                      child: FaIcon(FontAwesomeIcons.exchangeAlt),
                      backgroundColor: Colors.red,
                      onPressed: () {
                        print("OK");
                      }),
                  SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: "btn2",
                    onPressed: () {
                      // showMaterialModalBottomSheet(
                      //   context: context,
                      //   builder: (context, scrollController) => ProductInCartScreen(
                      //     listProduct: listProduct,
                      //     addProductToCart: addOrderedProduct,
                      //   ),
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductInCartScreen(
                                  listProduct: listProduct,
                                  addProductToCart: updateAmountProduct,
                                )),
                      );
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart),
                          Text(counter.toString(),
                              style: TextStyle(fontSize: 20)),
                        ]),
                    backgroundColor: Colors.blue,
                  ),
                  listProduct.isNotEmpty
                      ? Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: RaisedButton(
                                  color: Colors.amberAccent,
                                  onPressed: () {
                                    createOrder(listProduct, 'admin', 'open',
                                        (args.table.id).toString(), "0");
                                    print("Lưu");
                                    Navigator.pop(context);
                                  },
                                  child: Text("Lưu"),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: RaisedButton(
                                  color: Colors.pinkAccent,
                                  onPressed: () {
                                    print("thanh toán");
                                  },
                                  child: Text(
                                    "Thanh toán",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
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

class ProductComponent extends StatefulWidget {
  final Products products;
  final Function incrementCounter;
  final Function decrementCounter;
  final Function addProductToCart;
  final isUpdateInCart;
  ProductComponent(
      {this.products,
      this.incrementCounter,
      this.decrementCounter,
      this.addProductToCart,
      this.isUpdateInCart,
      key})
      : super(key: key);

  @override
  _ProductComponentState createState() => _ProductComponentState();
}

class _ProductComponentState extends State<ProductComponent> {
  int productCounter = 0;
  Products product = new Products();

  final formatter = new NumberFormat("#.###");
  @override
  Widget build(BuildContext context) {
    if (widget.isUpdateInCart == true) {
      if (widget.products.amount == null)
        productCounter = 0;
      else
        productCounter = widget.products.amount;
    }

    return Builder(
      builder: (context) {
        return Card(
          color: Colors.white70,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              GridTile(
                header: Center(
                  child: Text(
                    widget.products.productName,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.024),
                  ),
                ),
                footer: Container(
                  child: Stack(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      productCounter != 0
                          ? SizedBox(
                              height: 50,
                              width: 50,
                              child: Card(
                                shadowColor: Colors.blue,
                                color: Colors.white,
                                child: IconButton(
                                    iconSize: 20,
                                    padding: EdgeInsets.all(0.0),
                                    color: Colors.red,
                                    icon: FaIcon(FontAwesomeIcons.minus),
                                    onPressed: () {
                                      print('OK');
                                      widget.decrementCounter();

                                      setState(
                                        () {
                                          productCounter--;
                                          widget.products.amount =
                                              productCounter;
                                          widget.addProductToCart(
                                              widget.products);
                                        }, //Decrement product
                                      );
                                    }),
                              ),
                            )
                          : Container(),
                      // Padding(
                      //   padding: EdgeInsets.all(10),
                      //   child: Text(
                      //     formatter
                      //         .format(int.parse(widget.products.price)),
                      //     style: TextStyle(
                      //         fontSize:
                      //             MediaQuery.of(context).size.height *
                      //                 0.026),
                      //   ),
                      // ),
                      // SizedBox(
                      //     width: MediaQuery.of(context).size.width / 15)
                      Padding(
                        child: Center(
                          child: Text(
                            formatter.format(int.parse(widget.products.price)),
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.026),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      )
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: InkWell(
                    child: Card(
                      shadowColor: Colors.black,
                      child: Image.network(
                          StaticValue.path + '${widget.products.mainImage}',
                          fit: BoxFit.fill),
                    ),
                    onTap: () {
                      widget.incrementCounter(); //tăng số trong floating
                      setState(() {
                        //   print(productCounter);
                        productCounter++;
                        widget.products.amount = productCounter;
                        widget.addProductToCart(widget.products);
                      });
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 30, 30, 0),
                child: Text(
                  productCounter != 0 ? 'x${productCounter.toString()}' : '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.027,
                    color: Colors.purpleAccent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
