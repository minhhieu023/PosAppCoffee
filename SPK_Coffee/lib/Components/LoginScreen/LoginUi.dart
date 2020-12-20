import 'package:SPK_Coffee/Services/Services.dart';
import 'package:SPK_Coffee/Services/SocketManager.dart';
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
    return SingleChildScrollView(
      child: Column(
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
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600)
                        return Padding(
                          padding: EdgeInsets.only(left: 40, bottom: 10),
                          child: Text(
                            "SPK Coffee! Say hi",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        );
                      else //tablet
                        return Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.3,
                              bottom: 10),
                          child: Text(
                            "SPK Coffee! Say hi",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        );
                    },
                  ),
                  inputWigetTablet(
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
      ),
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
    return Container(
      width: MediaQuery.of(mContext).size.width * 0.40,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Stack(
          alignment: Alignment(1.0, 0.0),
          children: <Widget>[
            InkWell(
              onTap: () async {
                int isTrue = await serviceManager.loginEmployee(
                    userName.text, passWord.text);
                if (isTrue == 1) {
                  SharedPreferences prefs = await _prefs;
                  if (prefs.getString("role") == "admin") {
                    Navigator.pushReplacementNamed(mContext, "/Dashboard");
                  } else if (prefs.getString("role") == "waiter") {
                    Navigator.pushReplacementNamed(mContext, "/Services");
                  } else if (prefs.getString('role') == 'bartender')
                    Navigator.pushReplacementNamed(mContext, "/Kitchen");
                  SocketManagement().makeMessage("login",
                      data: {"id": userName.text}, isHaveData: true);
                } else {
                  showDialog(
                      context: mContext,
                      builder: (_) => new AlertDialog(
                            title: new Text("Error"),
                            content: new Text(
                                "The username or password is incorrect"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Ok'),
                                onPressed: () {
                                  Navigator.of(mContext).pop();
                                },
                              )
                            ],
                          ));
                }
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
          ],
        ),
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
