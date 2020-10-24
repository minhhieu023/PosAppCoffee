import 'dart:convert';

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
    final response = await http.get('http://172.16.99.24:8000/category/all');

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
    final response = await http.get('http://192.168.68.119:8000/area');
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
    final response = await http.get('http://192.168.68.119:8000/table');
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
}
