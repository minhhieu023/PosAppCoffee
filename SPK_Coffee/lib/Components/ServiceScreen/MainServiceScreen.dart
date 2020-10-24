import 'package:SPK_Coffee/Models/Area.dart';
import 'package:SPK_Coffee/SeedData/Data.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:SPK_Coffee/Models/Table.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainServiceScreen extends StatefulWidget {
  @override
  _MainServiceScreenState createState() => _MainServiceScreenState();
}

class _MainServiceScreenState extends State<MainServiceScreen> {
  ServiceManager _serviceManager;
  SeedData seedData = new SeedData();
  Future<List<CoffeeTable>> _tables;
  Future<List<Area>> _areas;
  int chooseArea;
  @override
  void initState() {
    chooseArea = 0;
    super.initState();
    _serviceManager = ServiceManager();
    _areas = _serviceManager.getArea();
    _tables = _serviceManager.getTable();
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
            child: areaWidget(_areas, chooseArea, setStateArea: setStateArea),
          ),
          listTable(_tables, chooseArea),
        ],
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
      }
      //loading
      return SpinKitCircle(
        color: Colors.green,
      );
    },
  );
}

Widget listTable(Future<List<CoffeeTable>> tables, int chooseArea) {
  return FutureBuilder(
    future: tables,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<CoffeeTable> list = new List<CoffeeTable>();
        if (chooseArea == 0) {
          list = snapshot.data;
        } else {
          snapshot.data.forEach((element) {
            if (element.id == chooseArea) list.add(element);
          });
        }
        final orientation = MediaQuery.of(context).orientation;
        return Flexible(
          child: GridView.builder(
            itemCount: list.length,
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
                          child: Text(list[index].id.toString()),
                        ),
                        footer: Center(child: Text(list[index].name)),
                        child: list[index].isEmpty
                            ? Image.asset("assets/img/inactive-table.png")
                            : Image.asset("assets/img/active-table.png")),
                  ));
            },
          ),
        );
      }
      //loading
      return SpinKitCircle(
        color: Colors.green,
      );
    },
  );
}
