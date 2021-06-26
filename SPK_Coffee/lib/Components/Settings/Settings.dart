import 'package:SPK_Coffee/Components/Settings/EditProfile.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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

  @override
  Widget build(BuildContext context) {
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
                  icon: Icons.settings_outlined),
              actionRow(
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
