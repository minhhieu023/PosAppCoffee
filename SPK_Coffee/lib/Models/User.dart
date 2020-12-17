class User {
  String status;
  String userName;
  String name;
  String role;

  User({this.status, this.userName, this.name, this.role});

  User.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userName = json['userName'];
    name = json['name'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['userName'] = this.userName;
    data['name'] = this.name;
    data['role'] = this.role;
    return data;
  }
}
