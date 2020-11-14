import 'package:SPK_Coffee/Models/Order.dart';

class OrderList {
  List<Order> data;
  List<OrderTable> tables;
  List<ProductsInfo> productsInfo;

  OrderList({this.data, this.tables, this.productsInfo});

  OrderList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Order>();
      json['data'].forEach((v) {
        data.add(new Order.fromJson(v));
      });
    }
    if (json['tables'] != null) {
      tables = new List<OrderTable>();
      json['tables'].forEach((v) {
        tables.add(new OrderTable.fromJson(v));
      });
    }
    if (json['productsInfo'] != null) {
      productsInfo = new List<ProductsInfo>();
      json['productsInfo'].forEach((v) {
        productsInfo.add(new ProductsInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.tables != null) {
      data['tables'] = this.tables.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
