import 'dart:convert';

import 'package:SPK_Coffee/Models/OrderList.dart';
import 'package:SPK_Coffee/Models/Area.dart';
import 'package:SPK_Coffee/Models/Category.dart';
import 'package:SPK_Coffee/Models/Product.dart';
import 'package:SPK_Coffee/Models/Table.dart';
import 'package:http/http.dart' as http;

class ServiceManager {
  final _href = 'https://caffeeshopbackend.herokuapp.com';
  ServiceManager();
  Future<ListProduct> getProduct() async {
    final response = await http.get(_href + '/products/all');

    if (response.statusCode == 200) {
      print(response.body);
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ListProduct.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Category> getProductWithCategory() async {
    final response = await http.get('$_href/category/all');

    if (response.statusCode == 200) {
      // print(response.body);
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Category.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future<List<Area>> getArea() async {
    final response = await http.get('$_href/area');
    if (response.statusCode == 200) {
      List<Area> areas = [];
      jsonDecode(response.body)['data'].forEach((item) {
        areas.add(new Area.fromJson(item));
      });
      return areas;
    } else {
      return null;
    }
  }

  Future<List<CoffeeTable>> getTable() async {
    final response = await http.get('$_href/table');
    if (response.statusCode == 200) {
      List<CoffeeTable> tables = [];
      jsonDecode(response.body)['data'].forEach((item) {
        tables.add(new CoffeeTable.fromJson(item));
      });

      return tables;
    } else {
      return null;
    }
  }

  Future<OrderList> getAllOrders() async {
    final response = await http.get('$_href/kitchen');
    // print(response.body);
    if (response.statusCode == 200) {
      OrderList orderList = OrderList.fromJson(jsonDecode(response.body));
      return orderList;
    }
    return null;
  }

  Future<OrderList> updateOrder(String id, String state) async {
    final res = await http.post("$_href/kitchen",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{'id': id, 'state': state}));
    if (res.statusCode == 200) {
      OrderList orderList = OrderList.fromJson(jsonDecode(res.body));
      return orderList;
    }
    return null;
  }
}
