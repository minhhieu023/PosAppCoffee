import 'package:SPK_Coffee/Components/Settings/AccountSetting.dart';
import 'package:SPK_Coffee/Components/Settings/EditProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:screen_loader/screen_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with ScreenLoader<Settings> {
  bool notification = true;
  Widget actionRow(
      {@required String actionName,
      dynamic Function() onTap,
      @required IconData icon}) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: Icon(icon, color: Colors.black),
                flex: 1,
              ),
              Expanded(
                child: Text(actionName, style: TextStyle(fontSize: 17)),
                flex: 8,
              ),
              Expanded(
                child: Icon(Icons.arrow_forward_ios, color: Colors.black),
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget toggleNotificationRow(
      {@required String actionName,
      dynamic Function() onTap,
      @required IconData icon}) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: Icon(icon, color: Colors.black),
                flex: 1,
              ),
              Expanded(
                child: Text(actionName, style: TextStyle(fontSize: 17)),
                flex: 7,
              ),
              Expanded(
                child: FlutterSwitch(
                    value: notification,
                    onToggle: (value) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setInt("priority", value == true ? 4 : 1);
                      setState(() {
                        notification = value;
                      });
                    }),
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalStorage();
  }

  Future<void> getLocalStorage() async {
    SharedPreferences prefs = await this.performFuture(() async {
      return await SharedPreferences.getInstance();
    });
    if (prefs.getInt("priority") == null) {
      prefs.setInt("priority", 4);
      setState(() {
        notification = true;
      });
    } else {
      setState(() {
        notification = prefs.getInt("priority") == 4 ? true : false;
      });
    }
  }

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              // ---------------------------------------------------------------- title ----------------------------------------------------------------
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10, bottom: 20),
                child: Text("Settings",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              // ---------------------------------------------------------------- Edit Profile -----------------------------------------------------------
              actionRow(
                  actionName: "Edit Profile",
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => EditProfile()));
                  },
                  icon: Icons.person_outline),
              // Account settings
              actionRow(
                  actionName: "Account Settings",
                  icon: Icons.settings_outlined,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => AccountSetting()));
                  }),
              toggleNotificationRow(
                  actionName: "Notifications",
                  icon: Icons.notifications_outlined),
              Divider(
                thickness: 0.5,
              ),
              actionRow(actionName: "Help", icon: Icons.help_outline_outlined),
              actionRow(actionName: "About Us", icon: Icons.info_outline),
              Divider(
                thickness: 0.5,
              ),
              actionRow(actionName: "Logout", icon: Icons.logout)
            ],
          ),
        ),
      ),
    );
  }
}
