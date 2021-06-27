import 'package:SPK_Coffee/Components/Common/CustomTextformField.dart';
import 'package:SPK_Coffee/Components/Common/GlobalFormKey.dart';
import 'package:SPK_Coffee/Components/Common/ShowPopUpModal.dart';
import 'package:SPK_Coffee/Models/EmployeeInfo.dart';
import 'package:SPK_Coffee/Models/ProviderModels/UserProvider.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/provider.dart';
import 'package:screen_loader/screen_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with ScreenLoader<EditProfile> {
  TextEditingController fullNameController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  String radioTypeValue;
  List<String> actionsType = ["Male", "Female", "Other"];
  Widget inputRow({String label, TextEditingController controller}) {
    return Container(
      child: customTextFormField(context, title: label, controller: controller),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    radioTypeValue = actionsType[2];
    getInitData();
  }

  Future<void> getInitData() async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    CurrentUser emp = await this.performFuture(() async {
      return await ServiceManager()
          .getIndividualEmployee(pref.getString("employeeId"));
    });
    if (emp != null) {
      user.setCurrentUser(emp);
      setState(() {
        fullNameController.text = user.currentUser.name;
        ageController.text = user.currentUser.age.toString();
        phoneController.text = user.currentUser.phoneNumber;
        radioTypeValue = user.currentUser.sex == true
            ? "Male"
            : (user.currentUser.sex == null ? "Other" : "Female");
      });
    }
  }

  Future<void> submitForm() async {
    if (GlobalFormKey.updateEmp.currentState.validate()) {
      // api: implement
      UserProvider user = Provider.of<UserProvider>(context, listen: false);
      CurrentUser modal = CurrentUser(
          id: user.currentUser.id,
          name: fullNameController.text,
          age: int.tryParse(ageController.text),
          phoneNumber: phoneController.text,
          sex: radioTypeValue == "Male"
              ? true
              : radioTypeValue == "Female"
                  ? false
                  : null);
      bool result = await ServiceManager().updateCurrentUser(modal);
      if (result == true) {
        getInitData();
        return await showSuccessDialog(context,
            title: "Success", message: "Update your profile successfully!");
      } else {
        return await showFailDialog(context,
            title: "Error!", message: "Update Fail. Try again later...");
      }
    } else {
      return await showFailDialog(context,
          title: "Error!", message: "Please check input ");
    }
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
          child: Form(
              key: GlobalFormKey.updateEmp,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                    child: Text(
                      "Edit Profile",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/img/bartender.png"),
                      radius: 60,
                    ),
                  ),
                  inputRow(label: "Full name", controller: fullNameController),
                  numberTextFormField(context, ageController, title: "Age"),
                  inputRow(label: "Phone", controller: phoneController),
                  // sex
                  Row(
                    children: [
                      Expanded(child: Container(), flex: 1),
                      Expanded(
                        child: Text("Gender:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue)),
                        flex: 8,
                      ),
                      Expanded(child: Container(), flex: 1),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RadioGroup.builder(
                          direction: Axis.horizontal,
                          groupValue: radioTypeValue,
                          onChanged: (value) {
                            setState(() {
                              radioTypeValue = value;
                            });
                          },
                          items: actionsType,
                          itemBuilder: (item) => RadioButtonBuilder(item)),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Text("Save Changes",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        await submitForm();
                      },
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
