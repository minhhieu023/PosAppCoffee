import 'package:SPK_Coffee/Models/ImployeeInformation.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:flutter/material.dart';

class EmployeeInformationProvider with ChangeNotifier {
  String status;
  List<EmployeeInfo> data = new List<EmployeeInfo>();
  EmployeeInformationProvider({this.status});
  // EmployeeInformationProvider();
  EmployeeInformationProvider.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<EmployeeInfo>();
      json['data'].forEach((v) {
        data.add(new EmployeeInfo.fromJson(v));
      });
    }
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }

  int get count {
    return data.length;
  }

  void removeEmployeeInformation(EmployeeInfo value) {
    print(value.name);
    data.remove(value);
    notifyListeners();
  }

  void addEmployee(EmployeeInfo value) {
    data.add(value);
    notifyListeners();
  }

  void getEmployee(List<EmployeeInfo> value) {
    ServiceManager serviceManager = new ServiceManager();

    if (status == "Ok") data = value;
    //  if (status == "Fail") return;
    notifyListeners();
  }
}
