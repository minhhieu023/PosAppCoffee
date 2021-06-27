class CurrentUser {
  String id;
  String name;
  int age;
  bool sex;
  String phoneNumber;

  CurrentUser({this.id, this.name, this.age, this.sex, this.phoneNumber});

  CurrentUser.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['name'];
    age = json['age'];
    sex = json['sex'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['name'] = this.name;
    data['age'] = this.age;
    data['sex'] = this.sex;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
