import 'package:SPK_Coffee/Models/Category.dart';
import 'package:SPK_Coffee/Models/Product.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  Future<Category> futureGetCategory;
  TabController tabController;
  @override
  void initState() {
    super.initState();
    futureGetCategory = getProductWithCategory();
    tabController = new TabController(vsync: this, length: 3);
    print(futureGetCategory.toString());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
        future: futureGetCategory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Order"),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TabBar(
                    controller: tabController,
                    tabs: snapshot.data.data.map((e) {
                      return Tab(
                        child: Text(
                          "${e.name}",
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: new BubbleTabIndicator(
                      indicatorHeight: 25.0,
                      indicatorColor: Colors.blueAccent,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                  ),
                  TabBarView(
                    controller: tabController,
                    children: [Text("Food"), Text("Drink"), Text("Others")],
                  ),
                  //#region
                  // FutureBuilder<Category>(
                  //   future: futureGetCategory,
                  //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //     if (snapshot.hasData)
                  //       return Expanded(
                  //         child: Column(children: <Widget>[
                  //           Container(
                  //               height:
                  //                   MediaQuery.of(context).size.height * 0.3,
                  //               child: categoryView(snapshot)),
                  //         ]),
                  //       );
                  //     else {
                  //       return CircularProgressIndicator();
                  //     }
                  //   },
                  // )
                  //#endregi
                ],
              ),
            );
          } else
            return Scaffold(
                appBar: AppBar(
                  title: Text("Order"),
                ),
                body: CircularProgressIndicator());
        });
  }
}

Widget productView(AsyncSnapshot<Category> snapshot) {
  return null;
}

List<Widget> categoryInView(AsyncSnapshot<Category> snapshot) {
  var listCategory = snapshot.data.data;
  List<Widget> listCategoryInView;
  listCategory.forEach((element) {
    listCategoryInView.add(Text(element.name));
    return listCategory;
  });
}

Widget categoryView(AsyncSnapshot<Category> snapshot) {
  var listCategory = snapshot.data.data;

  //print(listCategory[1].name);
  return Builder(
    builder: (context) {
      return GridView.builder(
        itemCount: listCategory.length,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                (MediaQuery.of(context).orientation == Orientation.portrait)
                    ? 3
                    : 3),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            //shadowColor: Colors.black,
            child: Text(listCategory[index].name),
          );
        },
      );
    },
  );
}
