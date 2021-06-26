class UserModel {
  String status;
  String userName;
  String name;
  String role;
  String storeId;
  String storeName;

  UserModel(
      {this.status,
      this.userName,
      this.name,
      this.role,
      this.storeId,
      this.storeName});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userName = json['userName'];
    name = json['name'];
    role = json['role'];
    storeId = json['storeId'];
    storeName = json['storeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['userName'] = this.userName;
    data['name'] = this.name;
    data['role'] = this.role;
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    return data;
  }
}
