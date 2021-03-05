import 'package:SPK_Coffee/Components/Manage/EmployeeUI.dart';
import 'package:SPK_Coffee/Models/ImployeeInformation.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EmployeeListView extends StatefulWidget {
  EmployeeListView({Key key}) : super(key: key);

  @override
  _EmployeeListViewState createState() => _EmployeeListViewState();
}

class _EmployeeListViewState extends State<EmployeeListView> {
  Future<EmployeeInformation> getAllEmployeeInformation() async {
    ServiceManager serviceManager = new ServiceManager();
    return (await serviceManager.getAllEmployeeInformation());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EmployeeInformation>(
      future: getAllEmployeeInformation(),
      builder: (context, snapshot) {
        //   listEmployee = snapshot.data;

        //print(snapshot.data.length);
        if (snapshot.hasData) {
          //  print(snapshot.data[0].name);
          return ListView.builder(
              itemCount: snapshot.data.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Employee(
                  employeeInfo: snapshot.data.data[index],
                );
              });
        } else
          return SpinKitFadingCircle(
            color: Colors.green,
          );
      },
    );
  }
}
