import 'package:SPK_Coffee/Components/Common/ShowPopUpModal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ndialog/ndialog.dart';
import 'package:screen_loader/screen_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({Key key}) : super(key: key);

  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting>
    with ScreenLoader<AccountSetting> {
  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  Future<void> changeColor(Color color) async {
    setState(() => pickerColor = color);
  }

  Future<void> modalPicker() async {
    // raise the [showDialog] widget
    return NDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: changeColor,
          showLabel: true,
          pickerAreaHeightPercent: 0.8,
        ),
        // Use Material color picker:
        //
        // child: MaterialPicker(
        //   pickerColor: pickerColor,
        //   onColorChanged: changeColor,
        //   showLabel: true, // only on portrait mode
        // ),
        //
        // Use Block color picker:
        //
        // child: BlockPicker(
        //   pickerColor: currentColor,
        //   onColorChanged: changeColor,
        // ),
        //
        // child: MultipleChoiceBlockPicker(
        //   pickerColors: currentColors,
        //   onColorsChanged: changeColors,
        // ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Confirm'),
          onPressed: () async {
            setState(() => currentColor = pickerColor);
            SharedPreferences pref = await SharedPreferences.getInstance();

            pref.setString("appColor", pickerColor.toString().substring(6, 16));
            Navigator.of(context).pop();
            bool isOk = await showConfirmDialog(context,
                title: "Notification",
                content:
                    "You need to reload app to change the color. Or else you can restart it later.");
            if (isOk == true) {
              Phoenix.rebirth(context);
            }
          },
        ),
      ],
    ).show(context);
  }

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
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // title
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: Text(
                  "Account setting",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              actionRow(
                  actionName: "Themes",
                  icon: Icons.color_lens_outlined,
                  onTap: () async {
                    return await modalPicker();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
