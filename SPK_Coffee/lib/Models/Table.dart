import 'package:SPK_Coffee/Models/Area.dart';

class CoffeeTable {
  int id;
  String name;

  bool isEmpty;
  int areaId;

  CoffeeTable(this.id, this.name, this.areaId, this.isEmpty);
  CoffeeTable.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['Id']);
    name = json['name'];
    isEmpty = json['isEmpty'];
    areaId = int.parse(json['AreaId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['isEmpty'] = this.isEmpty;
    data['AreaId'] = this.areaId;
    return data;
  }
}
