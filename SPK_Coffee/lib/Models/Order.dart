import 'package:SPK_Coffee/Models/OrderDetail.dart';
import 'package:flutter/material.dart';

class Order {
  String id;
  String employeeId;
  String date;
  String state;
  String total;
  String discount;
  String voucherId;
  String note;
  String tableName;
  String endUserId;
  List<OrderDetail> details;
  List<ProductsInfo> productsInfo;
  Order(
      {this.id,
      this.employeeId,
      this.date,
      this.state,
      this.total,
      this.discount,
      this.details,
      this.voucherId,
      this.note,
      this.tableName,
      this.endUserId});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    voucherId = json['voucherId'] ?? " ";
    date = json['date'];
    note = json['note'] ?? " ";
    state = json['state'];
    total = json['total'];
    discount = json['discount'];
    tableName = json['tableName'] ?? "";
    endUserId = json['endUserId'] ?? null;
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
    data['endUserId'] = this.endUserId;
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
  String mainImage;
  ProductsInfo(
      {this.id, this.productName, this.processDuration, this.mainImage});

  ProductsInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    processDuration = json['processDuration'];
    mainImage = json['mainImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productName'] = this.productName;
    data['processDuration'] = this.processDuration;
    data['mainImage'] = this.mainImage;
    return data;
  }
}
