import 'package:SPK_Coffee/Models/Area.dart';
import 'package:SPK_Coffee/SeedData/Data.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:SPK_Coffee/Models/Table.dart';

class MainServiceScreen extends StatefulWidget {
  @override
  _MainServiceScreenState createState() => _MainServiceScreenState();
}

class _MainServiceScreenState extends State<MainServiceScreen> {
  SeedData seedData = new SeedData();
  int chooseArea;
  @override
  void initState() {
    chooseArea = 0;
    super.initState();
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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Khu vực"),
          Padding(
            padding: EdgeInsets.all((10)),
            child: areaWidget(seedData.listArea, chooseArea,
                setStateArea: setStateArea),
          ),
          listTable(seedData.listTables, chooseArea),
        ],
      ),
    );
  }
}

Widget areaWidget(List<Area> seedData, int chooseArea,
    {Function(int) setStateArea}) {
  List<Area> list = seedData;
  return Builder(
    builder: (context) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: list
              .map<Widget>(
                (data) => Container(
                  width: MediaQuery.of(context).size.width * 0.22,
                  height:
                      (MediaQuery.of(context).size.height - kToolbarHeight) /
                          12,
                  //padding: EdgeInsets.all((10)),
                  child: InkWell(
                    splashColor: Colors.amberAccent,
                    onTap: () => setStateArea(data.id),
                    child: Card(
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
      );
    },
  );
}

Widget listTable(List<CoffeeTable> seedData, int chooseArea) {
  List<CoffeeTable> seedDataTable = new List<CoffeeTable>();
  if (chooseArea == 0) {
    seedDataTable = seedData;
  } else {
    seedData.forEach((element) {
      if (element.areaId == chooseArea) seedDataTable.add(element);
    });
  }
  return Builder(
    builder: (context) {
      final orientation = MediaQuery.of(context).orientation;
      return Flexible(
        child: GridView.builder(
          itemCount: seedDataTable.length,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (orientation == Orientation.portrait) ? 3 : 3),
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/Order');
                },
                child: Card(
                  //shadowColor: Colors.black,
                  child: new GridTile(
                      header: Center(
                        child: Text(seedDataTable[index].areaId.toString()),
                      ),
                      footer: Center(child: Text(seedDataTable[index].name)),
                      child: seedDataTable[index].isEmpty
                          ? Image.asset("assets/img/inactive-table.png")
                          : Image.asset("assets/img/active-table.png")),
                ));
          },
        ),
      );
    },
  );
}
