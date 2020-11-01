import 'package:SPK_Coffee/Models/Category.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:SPK_Coffee/Utils/Config.dart';
import 'package:SPK_Coffee/Utils/StaticValue.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  final String tableID;
  final String areaID;
  final String tableName;
  const OrderScreen(
      {Key key,
      @required this.tableID,
      @required this.areaID,
      @required this.tableName})
      : super(key: key);
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  Future<Category> futureGetCategory;
  TabController tabController;
  int counter = 0;
  ServiceManager serviceManager;
  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      counter++;
    });
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
                title: Text("Order"),
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
                  unselectedLabelColor: Colors.blueAccent,
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
                          );
                        },
                      );
                    }
                  },
                ).toList(),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Add your onPressed code here!
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

// Widget productView(AsyncSnapshot<Category> snapshot) {
//   return null;
// }

// List<Widget> categoryInView(AsyncSnapshot<Category> snapshot) {
//   var listCategory = snapshot.data.data;
//   List<Widget> listCategoryInView;
//   listCategory.forEach((element) {
//     listCategoryInView.add(Text(element.name));
//     return listCategory;
//   });
// }
class ProductComponent extends StatefulWidget {
  final Products products;
  final Function incrementCounter;
  final Function decrementCounter;
  ProductComponent(
      {this.products, this.incrementCounter, this.decrementCounter, Key key})
      : super(key: key);

  @override
  _ProductComponentState createState() => _ProductComponentState();
}

class _ProductComponentState extends State<ProductComponent> {
  int productCounter = 0;
  final formatter = new NumberFormat("#,###");
  @override
  Widget build(BuildContext context) {
    //  print(StaticValue.path + '${widget.products.mainImage}');
    return Builder(
      builder: (context) {
        return Card(
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  widget.incrementCounter(); //tăng số trong floating
                  setState(() {
                    //   print(productCounter);
                    productCounter++;
                  });
                },
                child: GridTile(
                  header: Card(
                    //shadowColor: Colors.black,
                    child: Center(
                      child: Text(
                        widget.products.productName,
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.024),
                      ),
                    ),
                  ),
                  footer: Card(
                    child: Center(
                      child: Text(
                        formatter.format(int.parse(widget.products.price)),
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.023),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 24, 10, 24),
                    child: Image.network(
                        StaticValue.path + '${widget.products.mainImage}',
                        fit: BoxFit.fill),
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

// Widget product(Products products,
//     {Function decreaseCouting, Function increaseCouting}) {
//   return null;

//   var listCategoryWithProducts = snapshot.data.data.;
//  // listCategoryWithProducts.map((e) => null).toList();
//   //print(listCategory[1].name);
//   return Builder(
//     builder: (context) {
//       return GridView.builder(
//         itemCount: listCategoryWithProducts.products.lenght,
//         padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
//         gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount:
//                 (MediaQuery.of(context).orientation == Orientation.portrait)
//                     ? 3
//                     : 3),
//         itemBuilder: (BuildContext context, int index) {
//           return Card(
//             //shadowColor: Colors.black,
//             child: Text(listCategory[index].name),
//           );
//         },
//       );
//     },
//   );
// }

//Counting product
int countingProduct(int counter, bool isPlus) {
  return isPlus == true ? counter++ : counter--;
}

//Minus and plus for card
// Container(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   IconButton(
//                     icon: FaIcon(FontAwesomeIcons.minus),
//                     onPressed: () => countingProduct(counter, false),
//                     color: Colors.blueAccent,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(20),
//                     child: Text('0'),
//                   ),
//                   IconButton(
//                     icon: FaIcon(FontAwesomeIcons.plus),
//                     onPressed: () => countingProduct(counter, true),
//                     color: Colors.blueAccent,
//                   ),
//                 ],
//               ),
//             ),
