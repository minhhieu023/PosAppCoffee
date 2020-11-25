import 'package:SPK_Coffee/Services/Services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'InputWidget.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userName = new TextEditingController();
  TextEditingController passWord = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.3),
        ),
        Column(
          children: <Widget>[
            ///holds email header and inputField
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 40, bottom: 10),
                  child: Text(
                    "SPK Coffee! Say hi",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                inputWiget(
                  context: context,
                  bottomRight: 30.0,
                  topRight: 30.0,
                  userName: userName,
                  passWord: passWord,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 50),
            ),
            roundedRectButton(
              "Login",
              signInGradients,
              userName,
              passWord,
              false,
            ),
            //roundedRectButton("Create an Account", signUpGradients, false),
          ],
        )
      ],
    );
  }
}

Widget roundedRectButton(
    String title,
    List<Color> gradient,
    TextEditingController userName,
    TextEditingController passWord,
    bool isEndIconVisible) {
  ServiceManager serviceManager = new ServiceManager();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  return Builder(builder: (BuildContext mContext) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Stack(
        alignment: Alignment(1.0, 0.0),
        children: <Widget>[
          InkWell(
            onTap: () async {
              await serviceManager.loginEmployee(userName.text, passWord.text);
              SharedPreferences prefs = await _prefs;
              if (prefs.getString("role") == "admin") {
                Navigator.pushReplacementNamed(mContext, "/Dashboard");
              } else if (prefs.getString("role") == "waiter") {
                Navigator.pushReplacementNamed(mContext, "/Services");
              } else if (prefs.getString('role') == 'bartender')
                Navigator.pushReplacementNamed(mContext, "/Kitchen");
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(mContext).size.width / 1.7,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: Text(title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
              padding: EdgeInsets.only(top: 16, bottom: 16),
            ),
          ),
          Visibility(
            visible: isEndIconVisible,
            child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: ImageIcon(
                  AssetImage("assets/img/ic_forward.png"),
                  size: 30,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  });
}

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];

const List<Color> signUpGradients = [
  Color(0xFFFF9945),
  Color(0xFFFc6076),
];
