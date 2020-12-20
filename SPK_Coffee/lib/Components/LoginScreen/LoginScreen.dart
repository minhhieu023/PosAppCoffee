import 'package:SPK_Coffee/Components/Common/LoadingScreenCustom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Background.dart';
import 'LoginUi.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          //  loadingScreen(),
          Background(),
          Login(),
        ],
      ),
    );
  }
}
