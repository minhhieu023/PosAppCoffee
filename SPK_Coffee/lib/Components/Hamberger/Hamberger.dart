import 'package:flutter/material.dart';

class Hamberger extends StatefulWidget {
  Hamberger({Key key}) : super(key: key);

  @override
  _HambergerState createState() => _HambergerState();
}

class _HambergerState extends State<Hamberger> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Text("Võ Minh Hiếu"),
                ListTile(
                  leading: Icon(
                    Icons.play_arrow,
                  ),
                  title: Text("Đang hoạt động"),
                )
              ],
            ),
          ),
          ListTile(
            title: Text("Item 1"),
          ),
          ListTile(
            title: Text("Item 2"),
          )
        ],
      ),
    );
  }
}
