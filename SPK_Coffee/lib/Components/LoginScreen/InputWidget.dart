import 'package:flutter/material.dart';

Widget inputWiget(
    {BuildContext context,
    final double topRight,
    double bottomRight,
    TextEditingController userName,
    TextEditingController passWord,
    Function actionFromParent}) {
  return Padding(
    padding: EdgeInsets.only(right: 40, bottom: 30),
    child: Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        child: Material(
            elevation: 10,
            color: Colors.white,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(bottomRight),
                    topRight: Radius.circular(topRight))),
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 40, right: 20, top: 10, bottom: 10),
                  child: TextField(
                    controller: userName,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter your user name",
                        hintStyle:
                            TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 40, right: 20, top: 10, bottom: 10),
                  child: TextField(
                    controller: passWord,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter your password",
                        hintStyle:
                            TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)),
                  ),
                ),
              ],
            )),
      ),
    ),
  );
}
