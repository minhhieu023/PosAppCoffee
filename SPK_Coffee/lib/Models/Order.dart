import 'package:SPK_Coffee/Models/OrderDetail.dart';
import 'package:flutter/material.dart';

class Order {
  String id;
  String employeeId;
  String date;
  String state;
  String total;
  String discount;
  List<OrderDetail> details;
  List<ProductsInfo> productsInfo;
  Order(
      {this.id,
      this.employeeId,
      this.date,
      this.state,
      this.total,
      this.discount,
      this.details});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    date = json['date'];
    state = json['state'];
    total = json['total'];
    discount = json['discount'];
    if (json['details'] != null) {
      details = new List<OrderDetail>();
      json['details'].forEach((v) {
        details.add(new OrderDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employeeId'] = this.employeeId;
    data['date'] = this.date;
    data['state'] = this.state;
    data['total'] = this.total;
    data['discount'] = this.discount;
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderTable {
  String tableid;
  String tablename;

  OrderTable({this.tableid, this.tablename});

  OrderTable.fromJson(Map<String, dynamic> json) {
    tableid = json['tableid'];
    tablename = json['tablename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tableid'] = this.tableid;
    data['tablename'] = this.tablename;
    return data;
  }
}

class ProductsInfo {
  String id;
  String productName;
  String processDuration;

  ProductsInfo({this.id, this.productName, this.processDuration});

  ProductsInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    processDuration = json['processDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productName'] = this.productName;
    data['processDuration'] = this.processDuration;
    return data;
  }
}
