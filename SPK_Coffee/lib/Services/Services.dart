import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:SPK_Coffee/Models/OrderList.dart';
import 'package:SPK_Coffee/Models/Area.dart';
import 'package:SPK_Coffee/Models/Category.dart';
import 'package:SPK_Coffee/Models/Product.dart';
import 'package:SPK_Coffee/Models/CoffeeTable.dart';
import 'package:SPK_Coffee/Services/SocketManager.dart';
import 'package:http/http.dart' as http;

class ServiceManager {
  final _href = 'http://103.153.73.107:8000';
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
    print('$_href/area');
    final response = await http.get('$_href/area');
    print(response);
    if (response.statusCode == 200) {
      List<Area> areas = [];
      jsonDecode(response.body)['data'].forEach((item) {
        areas.add(new Area.fromJson(item));
      });
      print(areas.toList());
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

  //Add a order with action: Open or Closed or Somethingelse
  Future<dynamic> createOrder(List<Products> listOrderDetail, String employeeId,
      String state, String tableId, String discount) async {
    //Map<String, dynamic> orderDetails = new Map<String, dynamic>();
    // Map<String, dynamic> listOrderDetailJson = new Map<String, dynamic>();
    List<Map<String, dynamic>> listOrderDetailJson =
        new List<Map<String, dynamic>>();
    listOrderDetail.forEach((element) {
      Map<String, dynamic> orderDetails = new Map<String, dynamic>();
      orderDetails['productId'] = element.id;
      orderDetails['amount'] = element.amount;
      orderDetails['price'] = element.price;
      listOrderDetailJson.add(orderDetails);
    });

    final response = await http
        .post(
          "$_href/order",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            'employeeId': employeeId,
            'state': state,
            'discount': discount,
            'tableId': tableId,
            'orderProducts': listOrderDetailJson.toList(),
          }),
        )
        .then(
            (value) => SocketManagement().makeMessage("makeUpdateOrderScreen"))
        .catchError((error) => print("fail"));
  }

  Future<int> loginEmployee(String userName, String passWord) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http
        .post(
          "$_href/login/employee",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(
              <String, dynamic>{'userName': userName, "password": passWord}),
        )
        .catchError((error) => print("fail"));
    if (response.statusCode == 200) {
      Map<String, dynamic> json = new Map<String, dynamic>();
      json = jsonDecode(response.body);
      if (json['status'] == 'Success') {
        String name = json['name'];
        await prefs.setString('name', name);
        String role = json['role'];
        await prefs.setString('role', role);
      }
      return 0;
    }
    return 0;
  }
}
