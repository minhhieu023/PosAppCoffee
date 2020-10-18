import 'package:SPK_Coffee/Models/Area.dart';

class CoffeeTable {
  final int tableId;
  final String name;

  final bool isEmpty;
  final int areaId;

  CoffeeTable(this.tableId, this.name, this.areaId, this.isEmpty);
}
