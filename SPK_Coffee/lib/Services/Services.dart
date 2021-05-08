import 'dart:convert';

import 'package:SPK_Coffee/Models/ImployeeInformation.dart';
import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/Models/Statistic.dart';

import 'package:SPK_Coffee/Models/Voucher.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:SPK_Coffee/Models/OrderList.dart';
import 'package:SPK_Coffee/Models/Area.dart';
import 'package:SPK_Coffee/Models/Category.dart';
import 'package:SPK_Coffee/Models/Product.dart';
import 'package:SPK_Coffee/Models/CoffeeTable.dart';
import 'package:SPK_Coffee/Services/SocketManager.dart';
import 'package:http/http.dart' as http;

class ServiceManager {
  final _href = 'http://hieuit.tech:8000/api';

  //final _href = 'http://10.11.210.15:8000/api';
  //final _href = 'http://192.168.1.34:8000/api';
  // final _href = 'https://caffeeshopbackend.herokuapp.com

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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post('$_href/category/all',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "storeId": prefs.getString("storeId") ?? "null"
        }));

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

  Future<OrderList> getActiveProducts() async {
    final response = await http.get('$_href/kitchen');
    if (response.statusCode == 200) {
      OrderList orderList = OrderList.fromJson(jsonDecode(response.body));
      return orderList;
    }
    return null;
  }

  Future<int> payOrder(String orderId, double tendered, double discount) async {
    final response = await http.post("$_href/cash/$orderId",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, dynamic>{'discount': discount, 'tendered': tendered}));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)[0]['pay'];
    }
    return null;
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

  Future<bool> updateOrderDetailsState(String id, String state) async {
    final response = await http.put('$_href/kitchen/detail/$id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{'state': state}));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<OrderList> getAllOrders() async {
    final response = await http.get('$_href/kitchen');
    // print(response.body);
    if (response.statusCode == 200) {
      OrderList orderList = OrderList.fromJson(jsonDecode(response.body));
      orderList.saveJson = jsonDecode(response.body);
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
        .then((value) async {
      await SocketManagement().makeMessage("makeUpdateOrderScreen");
      await SocketManagement().makeMessage("getUpdateDishKitchen");
    }).catchError((error) => print("fail"));
  }

  Future<OrderList> getReadyOrders() async {
    final response = await http.post(
      "$_href/cash",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{'state': 'ready'}),
    );
    if (response.statusCode == 200) {
      OrderList orderList = OrderList.fromJson(jsonDecode(response.body));
      orderList.saveJson = jsonDecode(response.body);
      return orderList;
    }
    return null;
  }

  Future<OrderList> getHistoryOrders(String date) async {
//    "date":"2020-12-05"
    final response = await http.post(
      "$_href/cash/filter",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{'date': date}),
    );
    if (response.statusCode == 200) {
      OrderList orderList = OrderList.fromJson(jsonDecode(response.body));
      orderList.saveJson = jsonDecode(response.body);
      return orderList;
    }
    return null;
  }

  Future<OrderList> getHistoryOrdersDayArrange(String date) async {
//    "date":"2020-12-05"
    final response = await http.post(
      "$_href/cash/filter",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{'date': date}),
    );
    if (response.statusCode == 200) {
      OrderList orderList = OrderList.fromJson(jsonDecode(response.body));
      orderList.saveJson = jsonDecode(response.body);
      return orderList;
    }
    return null;
  }

  Future<OrderList> getClosedOrders() async {
    final response = await http.post(
      "$_href/cash",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{'state': 'closed'}),
    );
    if (response.statusCode == 200) {
      OrderList orderList = OrderList.fromJson(jsonDecode(response.body));
      orderList.saveJson = jsonDecode(response.body);
      return orderList;
    }
    return null;
  }

  Future<OrderList> getReadyAndClosedOrders() async {
    final response = await http.get("$_href/cash");
    if (response.statusCode == 200) {
      OrderList orderList = OrderList.fromJson(jsonDecode(response.body));
      orderList.saveJson = jsonDecode(response.body);
      return orderList;
    }
    return null;
  }

  Future<VoucherList> getAllVoucher() async {
    final response = await http.get("$_href/voucher");
    if (response.statusCode == 200) {
      VoucherList voucherList = VoucherList.fromJson(jsonDecode(response.body));
      return voucherList;
    }
    return null;
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
              <String, dynamic>{"userName": userName, "password": passWord}),
        )
        .catchError((error) => print("fail"));
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> json = new Map<String, dynamic>();
      json = jsonDecode(response.body);
      if (json['status'] == 'Success') {
        String name = json['name'];
        await prefs.setString('name', name);
        String userNameGetRole = json['userName'];
        print(userNameGetRole);
        await prefs.setString('userName', userNameGetRole);
        String role = json['role'].toString().toLowerCase();
        await prefs.setString('role', role);
        String storeId = json["storeId"];
        await prefs.setString('storeId', storeId);
        return 1;
      }
      return 0;
    }
    return 0;
  }

  Future<String> mergeOrder(List<int> listTableToMerge) async {
    final response = await http
        .post(
          "$_href/table/merge",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            'id1': listTableToMerge[0],
            "id2": listTableToMerge[1]
          }),
        )
        .catchError((error) => print("fail"));
    if (response.statusCode == 200) {
      Map<String, dynamic> json = new Map<String, dynamic>();
      SocketManagement().makeMessage("getUpdateDishKitchen");
      SocketManagement().makeMessage("makeUpdateOrderScreen");
      json = jsonDecode(response.body);
      print(json);
      return "Merge has been successful";
    } else
      return "Failed! Try again!";
  }

  Future<String> payment(int id) async {
    final response = await http.post(
      "$_href/cash/$id",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    ).catchError((error) => print("fail"));
    if (response.statusCode == 200) {
      Map<String, dynamic> json = new Map<String, dynamic>();
      json = jsonDecode(response.body);
      print(json);
      return "Merge has been successful";
    } else
      return "Failed! Try again!";
  }

  Future<ListProduct> getOrderByTableId(String tableId) async {
    // http: //localhost:8000/order/getById/1
    final respone = await http.get(
      "$_href/order/getById/$tableId",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    ).catchError((error) => print("fail"));
    if (respone.statusCode == 200) {
      ListProduct listProduct = ListProduct.fromJson(jsonDecode(respone.body));
      return listProduct;
    }
    return null;
  }

  Future<Order> getOrderBasedTableId(String tableId) async {
    Order order;
    final respone = await http.get(
      "$_href/order/table-order/$tableId",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    ).catchError((error) => print("fail"));
    if (respone.statusCode == 200) {
      Map<String, dynamic> json = new Map<String, dynamic>();
      json = jsonDecode(respone.body);
      //print(json);
      order = Order.fromJson(jsonDecode(respone.body));
      print("Vo " + order.note);
    }
    return order;
  }

  Future<String> splitTable(String orderId) async {
    print("OrderId: " + orderId);
    final response = await http
        .post(
          "$_href/table/split",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            'orderId': orderId,
          }),
        )
        .catchError((error) => print(error));
    if (response.statusCode == 200) {
      SocketManagement().makeMessage("getUpdateDishKitchen");
      SocketManagement().makeMessage("makeUpdateOrderScreen");

      Map<String, dynamic> json = new Map<String, dynamic>();
      json = jsonDecode(response.body);
      print(json);
      return "Split has been successful";
    } else
      return "Failed! Try again!";
  }

  Future<String> takeAnAttendance() async {
    Future<SharedPreferences> _share = SharedPreferences.getInstance();
    SharedPreferences pref = await _share;
    final response = await http
        .post(
          "$_href/login/attendance",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            'userName': pref.getString("userName"),
          }),
        )
        .catchError((error) => print(error));
  }

  Future getAllEmployeeInformation() async {
    final response = await http.get(
      "$_href/employee",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      EmployeeInformation employeeInformationProvider =
          EmployeeInformation.fromJson(jsonDecode(response.body));
      //    if (employeeInformationProvider.status == "Ok")
      return employeeInformationProvider;
    } else {
      EmployeeInformation employeeInformationProvider =
          new EmployeeInformation(status: "fail");
      return employeeInformationProvider;
    }
  }

  Future createEmployee(String userName, String fullName, bool sex, String role,
      String age, String phoneNumber) async {
    final response = await http
        .post(
          "$_href/employee",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            "userName": userName,
            "fullName": fullName,
            "sex": sex,
            "role": role,
            "age": age,
            "phoneNumber": phoneNumber,
          }),
        )
        .catchError((error) => print("fail"));
  }

  Future addMoreProductIntoOrder(
      List<Products> listProduct, String orderId) async {
    List<Map<String, dynamic>> listOrderDetailJson =
        new List<Map<String, dynamic>>();
    listProduct.forEach((element) {
      Map<String, dynamic> orderDetails = new Map<String, dynamic>();
      orderDetails['productId'] = element.id;
      orderDetails['amount'] = element.amount;
      orderDetails['price'] = element.price;
      listOrderDetailJson.add(orderDetails);
    });
    final response = await http
        .post(
      "$_href/order/update",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{
        'orderProducts': listOrderDetailJson.toList(),
        'orderId': orderId,
      }),
    )
        .then((value) async {
      await SocketManagement().makeMessage("makeUpdateOrderScreen");
      await SocketManagement().makeMessage("getUpdateDishKitchen");
    }).catchError((error) => print("fail"));
  }

  Future<Map<String, dynamic>> getOneDayEarning(String date) async {
    final response = await http.post("$_href/statistical",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{'date': date}));
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return json;
    }
    return null;
  }

  Future<Statistic> getStatisticMonth(String date) async {
    final response = await http.post("$_href/statistical/month",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{'date': date}));
    if (response.statusCode == 200) {
      Statistic statistic = Statistic.fromJson(jsonDecode(response.body));
      return statistic;
    }
    return null;
  }
}
