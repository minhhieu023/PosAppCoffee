class Shippers {
  String id;
  String name;
  String age;
  String phoneNumber;
  String avt;
  String shipperInfo;

  Shippers(
      {this.id,
      this.name,
      this.age,
      this.phoneNumber,
      this.avt,
      this.shipperInfo});

  Shippers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    phoneNumber = json['phoneNumber'];
    avt = json['avt'];
    shipperInfo = json['shipperInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['age'] = this.age;
    data['phoneNumber'] = this.phoneNumber;
    data['avt'] = this.avt;
    data['shipperInfo'] = this.shipperInfo;
    return data;
  }
}
