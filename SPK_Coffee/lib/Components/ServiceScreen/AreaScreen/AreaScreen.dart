import 'package:SPK_Coffee/Components/ServiceScreen/AreaScreen/TableComponent.dart';
import 'package:SPK_Coffee/Models/Area.dart';
import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/SeedData/Data.dart';
import 'package:SPK_Coffee/Services/DataBaseManagement.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:SPK_Coffee/Models/CoffeeTable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainServiceScreen extends StatefulWidget {
  @override
  _MainServiceScreenState createState() => _MainServiceScreenState();
}

class _MainServiceScreenState extends State<MainServiceScreen>
    with SingleTickerProviderStateMixin {
  ServiceManager _serviceManager = new ServiceManager();
  SeedData seedData = new SeedData();
  Future<List<CoffeeTable>> _tables;
  Future<List<Area>> _areas;
  Future<Order> _order;
  Animation<double> _animation;
  AnimationController _animationController;
  int seleteProductToMerge = 0;
  bool isClickMenu = false;
  bool isMerge = false;
  bool isSplit = false;
  List<int> listTableToMerge;
  List<String> getOrderOnTableCore;
  int tableCounter = 0;
  bool isChange = false;
  int chooseArea;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    chooseArea = 0;
    // _serviceManager = ServiceManager();
    _areas = _serviceManager.getArea();
    _tables = _serviceManager.getTable();

    getTable();
    listTableToMerge = new List<int>();
    getOrderOnTableCore = new List<String>();

    super.initState();
  }

  Future<void> getTable() async {
    DataBaseManagement db = DataBaseManagement();
    await db.initDB();
    await db.getTable("Products");
    // await updatePropTable();
  }

  Future<void> updatePropTable() async {
    DataBaseManagement db = DataBaseManagement();
    await db.initDB();
    await db.updateRecord(
        "Products", "productDescription = 'Example'", "id = 1");
    // await db.dropTableIfExists("Products");
    await getTable();
  }

  void setStateWhenHaveOrder() {
    setState(() {
      // _serviceManager = ServiceManager();
      _areas = _serviceManager.getArea();
      _tables = _serviceManager.getTable();
    });
  }

  void setStateArea(int _chooseArea) {
    setState(() {
      print(_chooseArea);
      chooseArea = _chooseArea;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Service"),
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/Dashboard");
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Khu vực"),
          Padding(
            padding: EdgeInsets.all((10)),
            child: areaWidget(
              _areas,
              chooseArea,
              setStateArea: setStateArea,
            ),
          ),
          TableComponent(
            tables: _tables,
            chooseArea: chooseArea,
            isMerge: isMerge,
            isSplit: isSplit,
            listTableToMerge: listTableToMerge,
            tableCounter: tableCounter,
            setStateWhenHaveOrder: setStateWhenHaveOrder,
            getOrderOnTableCore: getOrderOnTableCore,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: isMerge == true || isSplit == true
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                  FloatingActionButton(
                      heroTag: "btn-check",
                      backgroundColor: Colors.green,
                      child: FaIcon(FontAwesomeIcons.check),
                      onPressed: () async {
                        String result;
                        if (isMerge)
                          result = await _serviceManager
                              .mergeOrder(listTableToMerge);
                        else if (isSplit) {
                          print("Area Screen: " + getOrderOnTableCore[0]);
                          String getString = getOrderOnTableCore[0];
                          result = await _serviceManager.splitTable(getString);
                        }
                        print(result);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                elevation: 24,
                                title: Text("Message"),
                                content: Text(result),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          if (result ==
                                              "Merge has been successful") {
                                            isMerge = false;
                                            isSplit = false;
                                            isClickMenu = false;
                                            listTableToMerge.clear();
                                            getOrderOnTableCore.clear();
                                          } else if (result ==
                                              "Split has been successful") {
                                            isMerge = false;
                                            isSplit = false;
                                            isClickMenu = false;
                                            listTableToMerge.clear();
                                            getOrderOnTableCore.clear();
                                          } else {}
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"))
                                ],
                              );
                            });
                      }),
                  SizedBox(height: 15),
                  FloatingActionButton(
                      heroTag: "btn-close",
                      backgroundColor: isMerge
                          ? Colors.amber
                          : isSplit
                              ? Colors.yellow
                              : Colors.white,
                      child: Icon(
                        Icons.close,
                      ),
                      onPressed: () {
                        setState(() {
                          isMerge = false;
                          isSplit = false;
                          isClickMenu = false;
                        });
                      })
                ])
          : FloatingActionBubble(
              // Menu items
              items: <Bubble>[
                // Floating action menu item
                Bubble(
                  title: "Split ",
                  iconColor: Colors.white,
                  bubbleColor: Colors.green,
                  titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    _animationController.reverse();
                    setState(() {
                      isSplit = true;
                      //isClickMenu = false;
                    });
                  },
                ),
                // Floating action menu item
                Bubble(
                  // icon: Icons.ac_unit,
                  title: "Merge",
                  //iconColor: Colors.black,
                  bubbleColor: Colors.amber,
                  titleStyle: TextStyle(fontSize: 16, color: Colors.black),
                  onPress: () {
                    _animationController.reverse();
                    setState(() {
                      isMerge = true;
                      print(isMerge);
                      //isClickMenu = false;
                    });
                  },
                ),
              ],
              // animation controller
              animation: _animation,

              // On pressed change animation state
              onPress: () {
                _animationController.isCompleted
                    ? _animationController.reverse()
                    : _animationController.forward();

                setState(() {
                  isClickMenu ? isClickMenu = false : isClickMenu = true;
                });
              },

              // Floating Action button Icon color
              iconColor: Colors.white,
              // Flaoting Action button Icon
              iconData: isClickMenu ? Icons.close : Icons.menu,
              backGroundColor: Colors.blue,
            ),
    );
  }
}

Widget areaWidget(Future<List<Area>> areas, int chooseArea,
    {Function(int) setStateArea}) {
  return FutureBuilder(
    future: areas,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<Area> list = snapshot.data;
        return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.22,
                  height:
                      (MediaQuery.of(context).size.height - kToolbarHeight) /
                          12,
                  //padding: EdgeInsets.all((10)),
                  child: InkWell(
                    splashColor: Colors.amberAccent,
                    onTap: () => setStateArea(0),
                    child: Card(
                      shadowColor: Colors.black,
                      color:
                          chooseArea == 0 ? Colors.deepOrangeAccent[100] : null,
                      child: Center(
                          child: AutoSizeText(
                        "All",
                        maxLines: 1,
                      )),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: list
                      .map<Widget>(
                        (data) => Container(
                          width: MediaQuery.of(context).size.width * 0.22,
                          height: (MediaQuery.of(context).size.height -
                                  kToolbarHeight) /
                              12,
                          //padding: EdgeInsets.all((10)),
                          child: InkWell(
                            splashColor: Colors.amberAccent,
                            onTap: () => setStateArea(data.id),
                            child: Card(
                              shadowColor: Colors.black,
                              color: data.id == chooseArea
                                  ? Colors.deepOrangeAccent[100]
                                  : null,
                              child: Center(
                                  child: AutoSizeText(
                                data.name,
                                maxLines: 1,
                              )),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ));
      }
      //loading
      return SpinKitCircle(
        color: Colors.green,
      );
    },
  );
}
