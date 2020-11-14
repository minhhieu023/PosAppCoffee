import 'package:SPK_Coffee/Components/ServiceScreen/ProductInCartScreen.dart';
import 'package:SPK_Coffee/Models/Category.dart';
import 'package:SPK_Coffee/Models/Product.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:SPK_Coffee/Utils/Config.dart';
import 'package:SPK_Coffee/Utils/StaticValue.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class OrderScreen extends StatefulWidget {
  final String tableID;
  final String areaID;
  final String tableName;
  OrderScreen({
    this.tableID,
    this.areaID,
    this.tableName,
    Key key,
  }) : super(key: key);
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  Future<Category> futureGetCategory;
  TabController tabController;
  List<Products> listProduct = new List<Products>();
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

  void updateAmountProduct(List<Products> listProduct) {
    setState(() {});
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
    return FutureBuilder<Category>(
        future: futureGetCategory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return Scaffold(
              appBar: AppBar(
                title: Text("Order - "),
                bottom: TabBar(
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
              body: TabBarView(
                controller: tabController,
                children: snapshot.data.data.map(
                  (e) {
                    {
                      final orientation = MediaQuery.of(context).orientation;
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
                          );
                        },
                      );
                    }
                  },
                ).toList(),
              ),
              floatingActionButton: FloatingActionButton(
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
                              addProductToCart: addOrderedProduct,
                            )),
                  );
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.shopping_cart),
                  Text(counter.toString(), style: TextStyle(fontSize: 20)),
                ]),
                backgroundColor: Colors.blue,
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
  ProductComponent(
      {this.products,
      this.incrementCounter,
      this.decrementCounter,
      this.addProductToCart,
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
    //  print(StaticValue.path + '${widget.products.mainImage}');
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
