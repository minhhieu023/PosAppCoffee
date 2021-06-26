import 'package:SPK_Coffee/Components/Common/CustomTextformField.dart';
import 'package:flutter/material.dart';

import 'package:screen_loader/screen_loader.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with ScreenLoader<EditProfile> {
  TextEditingController fullNameController = new TextEditingController();

  Widget inputRow({String label, TextEditingController controller}) {
    return Container(
      child: customTextFormField(context, title: label, controller: controller),
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
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 30),
                child: Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/img/bartender.png"),
                  radius: 60,
                ),
              ),
              inputRow(label: "Full name", controller: fullNameController)
            ],
          ),
        ),
      ),
    );
  }
}
