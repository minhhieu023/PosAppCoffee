class Area {
  int id;
  String name;
  String waiter1;
  String waiter2;
  int amountOfTable;
  Area(this.id, this.name, this.waiter1, this.amountOfTable, {this.waiter2});
  Area.fromJson(Map<String, dynamic> json) {
    this.id = int.parse(json['Id']);
    this.name = json['name'];
    this.waiter1 = json['waiter1'];
    this.waiter2 = json['waiter2'];
    this.amountOfTable = json['amountOfTable'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['name'] = this.name;
    data['waiter1'] = this.waiter1;
    data['waiter2'] = this.waiter2;
    data['amountOfTable'] = this.amountOfTable;
    return data;
  }
}
