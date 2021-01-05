import 'package:SPK_Coffee/Services/Services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Hamberger extends StatefulWidget {
  Hamberger({Key key}) : super(key: key);

  @override
  _HambergerState createState() => _HambergerState();
}

class _HambergerState extends State<Hamberger> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> getName() async {
    SharedPreferences prefs = await _prefs;
    return prefs.getString("name");
  }

  bool isTaking = true;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getName(),
        builder: (context, snapshot) {
          //  return
          if (snapshot.hasData)
            return Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                    child: Column(
                      children: [
                        CircleAvatar(),
                        Text(snapshot.data),
                        Text(
                          "Đang hoạt động",
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text("Information"),
                  ),
                  ListTile(
                    onTap: () async {
                      print(isTaking);
                      if (!isTaking) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                elevation: 24,
                                title: Text("Message"),
                                content:
                                    Text("You has taken an attendance before!"),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"))
                                ],
                              );
                            });
                        return;
                      }
                      print("OK");
                      ServiceManager serviceManager = new ServiceManager();
                      await serviceManager.takeAnAttendance();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              elevation: 24,
                              title: Text("Message"),
                              content: Text(
                                  "Taking Attendance has been successfull. Keep working"),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        setState(() {
                                          isTaking
                                              ? isTaking = false
                                              : isTaking = true;
                                        });
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"))
                              ],
                            );
                          });
                    },
                    title: Text("Take an attendance"),
                  ),
                  ListTile(title: Text("About"))
                ],
              ),
            );
          else
            return SpinKitCircle(
              color: Colors.blue,
            );
        });
  }
}
