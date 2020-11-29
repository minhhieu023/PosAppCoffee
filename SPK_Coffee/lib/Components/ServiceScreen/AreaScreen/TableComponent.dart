import 'package:SPK_Coffee/Components/ServiceScreen/OrderScreen.dart';
import 'package:SPK_Coffee/Models/CoffeeTable.dart';
import 'package:flutter/material.dart';

class TableComponent extends StatefulWidget {
  final Future<List<CoffeeTable>> tables;
  List<int> listTableToMerge;
  final int chooseArea;
  final bool isMerge;
  int tableCounter;
  TableComponent(
      {this.tables,
      this.chooseArea,
      this.isMerge,
      this.listTableToMerge,
      this.tableCounter,
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
                      (orientation == Orientation.portrait) ? 3 : 3),
              // ignore: missing_return
              itemBuilder: (BuildContext context, int index) {
                return TableWiget(
                  tableCoffee: list[index],
                  chooseArea: widget.chooseArea,
                  isMerge: widget.isMerge,
                  function: setSateCounter,
                  counter: widget.tableCounter,
                  listTableToMerge: widget.listTableToMerge,
                );
              },
            ),
          );
        }
        //loading
        return Container();
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
  List<int> listTableToMerge;
  TableWiget(
      {this.tableCoffee,
      this.chooseArea,
      this.isMerge,
      this.function,
      this.counter,
      this.listTableToMerge,
      key})
      : super(key: key);

  @override
  _TableWigetState createState() => _TableWigetState();
}

class _TableWigetState extends State<TableWiget> {
  bool selectedToMerge = false;
  @override
  void initState() {
    if (widget.counter == 0) {
      selectedToMerge = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.counter == 0) {
      setState(() {
        selectedToMerge = false;
      });
    }
    return InkWell(
      onTap: () {
        if (widget.counter > 2) return;
        if (widget.isMerge == false) {
          CoffeeTable currentTable = widget.tableCoffee;
          Navigator.pushNamed(
            context,
            '/Order',
            arguments: OrderScreen(
              table: currentTable,
            ),
          );
        } else {
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
      child: Card(
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
                child: Text(widget.tableCoffee.areaId.toString())),
          ),
          footer: Padding(
              padding: EdgeInsets.all((10)),
              child: Center(child: Text(widget.tableCoffee.name))),
          child: Card(
              color: selectedToMerge &&
                      widget.isMerge &&
                      !widget.tableCoffee.isEmpty
                  ? Colors.amber
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
    );
  }
}
