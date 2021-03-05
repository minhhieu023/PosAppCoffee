import 'package:SPK_Coffee/Utils/Feature.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  DashBoard({Key key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  Future<List<Feature>> getRole() async {
    List<Feature> listFeature = new List<Feature>();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("role") == 'admin') {
      featureForAdmin.forEach((element) {
        listFeature.add(element);
      });
    } else if (preferences.getString("role") == 'bartender') {
      featureForBartender.forEach((element) {
        listFeature.add(element);
      });
    } else if (preferences.getString("role") == "waiter") {
      featureForWaiter.forEach((element) {
        listFeature.add(element);
      });
    }
    return listFeature;
  }

  @override
  void initState() {
    // TODO: implement initState
    // getRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Feature>>(
      future: getRole(),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return dashBoard(snapshot.data);
        else
          return Container(child: CircularProgressIndicator());
      },
    );
  }
}

Widget dashBoard(List<Feature> listFeature) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < constraints.maxHeight)
        return verticalView(listFeature);
      else //tablet
        return verticalView(listFeature);
    },
  );
}

Widget verticalView(List<Feature> listFeature) {
  return Builder(
    builder: (context) {
      final orientation = MediaQuery.of(context).orientation;
      return Center(
        child: GridView.builder(
          itemCount: listFeature.length,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: ((MediaQuery.of(context).size.width - 20) / 2) /
                  ((MediaQuery.of(context).size.width - 20 - kToolbarHeight) /
                      2),
              crossAxisCount: ((orientation == Orientation.portrait) ? 2 : 4),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10),
          itemBuilder: (BuildContext context, int index) {
            return childFeature(listFeature[index]);
          },
        ),
      );
    },
  );
}

Widget horizonView(List<Feature> listFeature) {
  return Builder(builder: (context) {
    // double size = (MediaQuery.of(context).size.width - kToolbarHeight) / 3;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: (MediaQuery.of(context).size.width - kToolbarHeight) * 0.2,
          child: ListView.builder(
            itemCount: listFeature.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: listFeature[index].color,
                child: IconButton(
                  icon: Icon(listFeature[index].icon),
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/${listFeature[index].title}');
                  },
                ),
              );
            },
          ),
        ),
        Container(child: Text("Sayhi"))
      ],
    );
  });
}

Widget childFeature(Feature feature) {
  return Builder(builder: (context) {
    return Card(
      // margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      shadowColor: Colors.black,

      color: feature.color,
      child: InkWell(
        onTap: () async {
          if (feature.title == "Logout") {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            await preferences.clear();
            Navigator.pushNamed(context, '/');
          } else
            Navigator.pushNamed(context, '/${feature.title}');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(feature.icon, size: MediaQuery.of(context).size.height * 0.1),
            AutoSizeText(
              feature.title,
              maxLines: 2,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  });
}
