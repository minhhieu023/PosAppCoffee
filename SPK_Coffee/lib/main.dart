import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "SPK COFFEE",
            style:
                TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: mainPage(),
      ),
    );
  }
}

Widget mainPage() {
  return Center(
    child: GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: [
        Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.teal[100],
            ),
            child: Center(
                child: Column(
              children: [
                Icon(Icons.description, size: 125),
                AutoSizeText(
                  "KITCHEN",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ))),
        Container(child: Text("Home")),
      ],
    ),
  );
}
