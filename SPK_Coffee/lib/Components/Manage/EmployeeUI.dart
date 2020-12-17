import 'package:SPK_Coffee/Models/ImployeeInformation.dart';
import 'package:SPK_Coffee/Models/ProviderModels/EmployeeInformationProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Employee extends StatelessWidget {
  final EmployeeInfo employeeInfo;
  // final EmployeeInformationProvider listEmployee;

  const Employee({this.employeeInfo, key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var employeeList = Provider.of<EmployeeInformationProvider>(context);
    employeeList.addEmployee(employeeInfo);
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blueAccent),
      ),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: InkWell(
          onTap: () {
            print("touch");
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                    height:
                        MediaQuery.of(context).copyWith().size.height * 0.75,
                    child: Expanded(
                        child: Column(
                      children: [
                        Text(employeeInfo.name),
                        Text(employeeInfo.age.toString()),
                        Text(employeeInfo.sex ? "Male" : "Female"),
                        Text(employeeInfo.role),
                        Text(employeeInfo.phoneNumber != null
                            ? employeeInfo.phoneNumber
                            : "Unknown"),
                      ],
                    )));
              },
              isScrollControlled: true,
            );
          },
          splashColor: Theme.of(context).accentColor,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: ListTile(
              leading: Icon(FontAwesomeIcons.user),
              title: Text(
                employeeInfo.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: Text(employeeInfo.role.toString()),
              trailing: Icon(Icons.navigate_before),
            ),
          ),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
              caption: 'Edit',
              color: Colors.yellow,
              icon: Icons.edit,
              onTap: () {}),
          IconSlideAction(
            caption: 'Block',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              employeeList.removeEmployeeInformation(employeeInfo);
            },
          ),
        ],
      ),
    );
  }
}
