import 'dart:convert';

import 'package:SPK_Coffee/Models/Category.dart';
import 'package:SPK_Coffee/Models/Product.dart';
import 'package:http/http.dart' as http;

Future<ListProduct> getProduct() async {
  final response =
      await http.get('https://caffeeshopbackend.herokuapp.com/products/all');

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
    throw Exception();
  }
}
