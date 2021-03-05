import 'package:SPK_Coffee/Components/ServiceScreen/OrderScreen/OrderScreen.dart';
import 'package:SPK_Coffee/Models/CoffeeTable.dart';
import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TableComponent extends StatefulWidget {
  final Future<List<CoffeeTable>> tables;

  List<int> listTableToMerge;
  final int chooseArea;
  final bool isMerge;
  Function setStateWhenHaveOrder;
  // int chosseSplitTable;
  List<String> getOrderOnTableCore;
  int tableCounter;
  bool isSplit;
  TableComponent(
      {this.tables,
      this.getOrderOnTableCore,
      this.chooseArea,
      this.isMerge,
      this.isSplit,
      this.listTableToMerge,
      this.tableCounter,
      this.setStateWhenHaveOrder,
      //    this.chosseSplitTable,
      key})
      : super(key: key);

  @override
  _TableComponentState createState() => _TableComponentState();
}

class _TableComponentState extends State<TableComponent> {
  void setSateCounter(bool isOnTap) {
    setState(() {
      isOnTap ? widget.tableCounter++ : widget.tableCounter--;
    });
    print(widget.tableCounter);
  }

  Future<Order> getOrder(int tableID) {}
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.tables,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CoffeeTable> list = new List<CoffeeTable>();
          if (widget.chooseArea == 0) {
            list = snapshot.data;
          } else {
            snapshot.data.forEach((element) {
              if (element.areaId == widget.chooseArea) list.add(element);
            });
          }
          final orientation = MediaQuery.of(context).orientation;
          return Flexible(
            child: GridView.builder(
              itemCount: list.length,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (orientation == Orientation.portrait) ? 3 : 5),
              // ignore: missing_return
              itemBuilder: (BuildContext context, int index) {
                return TableWiget(
                    tableCoffee: list[index],
                    chooseArea: widget.chooseArea,
                    isMerge: widget.isMerge,
                    isSplit: widget.isSplit,
                    function: setSateCounter,
                    counter: widget.tableCounter,
                    listTableToMerge: widget.listTableToMerge,
                    setStateWhenHaveOrder: widget.setStateWhenHaveOrder,
                    getOrderOnTableCore: widget.getOrderOnTableCore);
              },
            ),
          );
        }
        //loading
        return Container(
          height: 0,
          width: 0,
        );
      },
    );
  }
}

class TableWiget extends StatefulWidget {
  final CoffeeTable tableCoffee;

  final int chooseArea;
  bool isMerge;
  Function function;
  int counter;
  List<String> getOrderOnTableCore;
  bool isSplit;
  List<int> listTableToMerge;

  Function setStateWhenHaveOrder;
  TableWiget(
      {this.tableCoffee,
      this.getOrderOnTableCore,
      this.chooseArea,
      this.isMerge,
      this.function,
      this.counter,
      this.isSplit,
      this.listTableToMerge,
      this.setStateWhenHaveOrder,
      key})
      : super(key: key);

  @override
  _TableWigetState createState() => _TableWigetState();
}

class _TableWigetState extends State<TableWiget> {
  ServiceManager _serviceManager = new ServiceManager();
  Future<Order> order;
  bool selectedToMerge = false;
  bool tableMergeCore;
  bool selecttedSplit = false;
  @override
  void initState() {
    if (widget.counter == 0) {
      selectedToMerge = false;
    }

    tableMergeCore = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.counter == 0) {
      setState(() {
        selectedToMerge = false;
      });
    }

    // return
    return widget.tableCoffee.isEmpty
        ? InkWell(
            onTap: () {
              if (widget.counter > 2) return;
              if (widget.isSplit == true) return;
              if (widget.isMerge == false) {
                CoffeeTable currentTable = widget.tableCoffee;
                if (widget.tableCoffee.isEmpty) {
                  Navigator.pushNamed(
                    context,
                    '/Order',
                    arguments: OrderScreen(
                      table: currentTable,
                      setStateWhenHaveOrder: widget.setStateWhenHaveOrder,
                    ),
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    '/Order',
                    arguments: OrderScreen(
                      table: currentTable,
                    ),
                  );
                }
              } else {
                if (widget.tableCoffee.isEmpty) return;

                setState(() {
                  if (selectedToMerge) {
                    widget.listTableToMerge.remove(widget.tableCoffee.id);
                    widget.function.call(false);
                    selectedToMerge = false;
                  } else {
                    if (widget.counter >= 2 && selectedToMerge == false)
                      return;
                    else {
                      selectedToMerge = true;
                      print(widget.listTableToMerge);
                      widget.listTableToMerge.add(widget.tableCoffee.id);
                      print(widget.listTableToMerge.toList());
                      widget.function.call(true);
                    }
                  }
                });
              }
            },
            child: Container(
              color: widget.isMerge == true &&
                      !widget.tableCoffee.isEmpty &&
                      widget.counter < 2
                  ? Colors.amber
                  : null,

              //shadowColor: Colors.black,
              child: new GridTile(
                header: Center(
                  child: Padding(
                      padding: EdgeInsets.all((10)),
                      child: Text(
                          ("Area " + widget.tableCoffee.areaId.toString()))),
                ),
                footer: Padding(
                    padding: EdgeInsets.all((10)),
                    child: Center(
                        child: Text("Table " + widget.tableCoffee.name))),
                child: Card(
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 2,
                    // shadowColor: Colors.white,
                    color: selectedToMerge &&
                            widget.isMerge &&
                            !widget.tableCoffee.isEmpty
                        ? Colors.amber
                        : Colors.white,
                    child: widget.tableCoffee.isEmpty
                        ? Image.asset("assets/img/inactive-table.png")
                        : Image.asset("assets/img/active-table.png")),
              ),
            ),
          )
        : FutureBuilder<Order>(
            future: _serviceManager
                .getOrderBasedTableId(widget.tableCoffee.id.toString()),
            builder: (BuildContext context, snapshot) {
              //print(tableMergeCore.toString() + " " + widget.tableCoffee.name);
              if (snapshot.hasData) {
                // print("Get note: " + snapshot.data.note + "1");
                if (snapshot.data.note != " ") {
                  var split = snapshot.data.note.split(" ");
                  //print(split);
                  if (split[1] != "by") {
                    tableMergeCore = true;
                    //  print("Vao true");
                  } else {
                    //  print("vao false");
                    tableMergeCore = false;
                  }
                } else {
                  //  print("nhanh 2");
                  tableMergeCore = false;
                }

                //print(tableMergeCore);
                return InkWell(
                  onTap: () {
                    print("state: " + tableMergeCore.toString());
                    if (!tableMergeCore && snapshot.data.note != " ") return;
                    if (widget.isSplit) {
                      if (!tableMergeCore)
                        return;
                      else {
                        setState(() {
                          selecttedSplit
                              ? selecttedSplit = false
                              : selecttedSplit = true;
                        });
                        print(snapshot.data.id);
                        print(widget.getOrderOnTableCore);
                        widget.getOrderOnTableCore.add(snapshot.data.id);
                        print(widget.getOrderOnTableCore.toList());
                      }
                    } else {
                      print("Is Split:" + widget.isSplit.toString());
                      if (widget.isSplit == true && !tableMergeCore) return;
                      if (widget.counter > 2) return;
                      if (widget.isMerge == false) {
                        CoffeeTable currentTable = widget.tableCoffee;
                        if (widget.tableCoffee.isEmpty) {
                          Navigator.pushNamed(
                            context,
                            '/Order',
                            arguments: OrderScreen(
                              orderId: snapshot.data.id,
                              table: currentTable,
                              setStateWhenHaveOrder:
                                  widget.setStateWhenHaveOrder,
                            ),
                          );
                        } else {
                          Navigator.pushNamed(
                            context,
                            '/Order',
                            arguments: OrderScreen(
                              orderId: snapshot.data.id,
                              table: currentTable,
                            ),
                          );
                        }
                      } else {
                        print("Select");
                        if (snapshot.data.note != " ") return;
                        setState(() {
                          if (selectedToMerge) {
                            widget.listTableToMerge
                                .remove(widget.tableCoffee.id);
                            widget.function.call(false);
                            selectedToMerge = false;
                          } else {
                            if (widget.counter >= 2 && selectedToMerge == false)
                              return;
                            else {
                              selectedToMerge = true;
                              print(widget.listTableToMerge);
                              widget.listTableToMerge
                                  .add(widget.tableCoffee.id);
                              print(widget.listTableToMerge.toList());
                              widget.function.call(true);
                            }
                          }
                        });
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      Card(
                        color: widget.isMerge == true &&
                                !widget.tableCoffee.isEmpty &&
                                widget.counter < 2
                            //Không có thông tin merge
                            ? Colors.amber
                            : widget.isSplit &&
                                    snapshot.data.note != " " &&
                                    tableMergeCore
                                ? Colors.green
                                : null,
                        //shadowColor: Colors.black,
                        child: new GridTile(
                          header: Center(
                            child: Padding(
                                padding: EdgeInsets.all((10)),
                                child: Text(("Area " +
                                    widget.tableCoffee.areaId.toString()))),
                          ),
                          footer: Padding(
                              padding: EdgeInsets.all((10)),
                              child: Center(
                                  child: Text(
                                      "Table " + widget.tableCoffee.name))),
                          child: Card(
                              color: selectedToMerge &&
                                      widget.isMerge &&
                                      !widget.tableCoffee.isEmpty
                                  ? Colors.amber
                                  : selecttedSplit &&
                                          widget.isSplit &&
                                          !widget.tableCoffee.isEmpty
                                      ? Colors.green
                                      : !tableMergeCore &&
                                              snapshot.data.note != " "
                                          ? Colors.grey[300]
                                          : Colors.white,
                              shadowColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              elevation: 2,
                              child: widget.tableCoffee.isEmpty
                                  ? Image.asset("assets/img/inactive-table.png")
                                  : Image.asset("assets/img/active-table.png")),
                        ),
                      ),
                      tableMergeCore
                          ? Text(
                              "Merged",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[700]),
                            )
                          : Container(height: 0, width: 0),
                    ],
                  ),
                );
              } else
                return Container(
                  height: 0,
                  width: 0,
                );
            });
  }
}
