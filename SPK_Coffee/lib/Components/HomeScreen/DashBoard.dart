import 'package:SPK_Coffee/Utils/Feature.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget dashBoard() {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < constraints.maxHeight)
        return verticalView();
      else //tablet
        return horizonView();
    },
  );
}

Widget verticalView() {
  return Builder(
    builder: (context) {
      return Center(
        child: GridView.builder(
          itemCount: listFeature.length,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: ((MediaQuery.of(context).size.width - 20) / 2) /
                  ((MediaQuery.of(context).size.width - 20 - kToolbarHeight) /
                      2),
              crossAxisCount: 2,
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

Widget horizonView() {
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
                  // child: ListTile(
                  //   leading: Icon(
                  //     listFeature[index].icon,
                  //     size: MediaQuery.of(context).size.height * 0.1,
                  //   ),
                  // title: Text(
                  //   listFeature[index].title,
                  //   //  maxLines: 1,
                  //   style: TextStyle(
                  //     fontSize: MediaQuery.of(context).sizre.height * 0.033,
                  //     //fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // focusColor: Colors.blueAccent,
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

      color: feature.color,
      child: InkWell(
        onTap: () {
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
