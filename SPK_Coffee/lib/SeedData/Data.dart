import 'package:SPK_Coffee/Models/Area.dart';
import 'package:SPK_Coffee/Models/Table.dart';

class SeedData {
  List<Area> listArea = [
    Area(0, "All", "Tien", 10),
    Area(1, "Thanh Long", "Tien", 5),
    Area(2, "Bạch Hổ", "Tien", 5),
    Area(3, "Chu Tước", "Hieu", 5),
    Area(4, "Huyền Vũ", "Tien", 5),
  ];

  List<CoffeeTable> listTables = [
    CoffeeTable(1, "A001", 1, true),
    CoffeeTable(2, "A002", 1, true),
    CoffeeTable(3, "A003", 1, true),
    CoffeeTable(4, "A004", 1, true),
    CoffeeTable(5, "A005", 1, false),
    CoffeeTable(6, "A006", 1, false),
    CoffeeTable(1, "B001", 2, true),
    CoffeeTable(2, "B002", 2, true),
    CoffeeTable(3, "B003", 2, false),
    CoffeeTable(4, "B004", 2, false),
    CoffeeTable(5, "B005", 2, true),
    CoffeeTable(6, "B006", 2, true),
  ];
}
