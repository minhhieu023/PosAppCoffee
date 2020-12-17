class EmployeeInformation {
  String status;
  List<EmployeeInfo> data;

  EmployeeInformation({this.status, this.data});

  EmployeeInformation.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<EmployeeInfo>();
      json['data'].forEach((v) {
        data.add(new EmployeeInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmployeeInfo {
  String id;
  String name;
  int age;
  bool sex;
  String role;
  Null online;
  Null phoneNumber;
  Null imgage;
  String createdAt;
  String updatedAt;
  String infor;
  Null employeeAccountId;

  EmployeeInfo(
      {this.id,
      this.name,
      this.age,
      this.sex,
      this.role,
      this.online,
      this.phoneNumber,
      this.imgage,
      this.createdAt,
      this.updatedAt,
      this.infor,
      this.employeeAccountId});

  EmployeeInfo.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['name'];
    age = json['age'];
    sex = json['sex'];
    role = json['role'];
    online = json['online'];
    phoneNumber = json['phoneNumber'];
    imgage = json['imgage'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    infor = json['infor'];
    employeeAccountId = json['EmployeeAccountId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['name'] = this.name;
    data['age'] = this.age;
    data['sex'] = this.sex;
    data['role'] = this.role;
    data['online'] = this.online;
    data['phoneNumber'] = this.phoneNumber;
    data['imgage'] = this.imgage;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['infor'] = this.infor;
    data['EmployeeAccountId'] = this.employeeAccountId;
    return data;
  }
}
