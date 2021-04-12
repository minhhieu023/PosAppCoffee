import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/Models/OrderDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrderDetailWid extends StatelessWidget {
  final OrderDetail detail;
  final List<ProductsInfo> productsInfo;
  OrderDetailWid({this.detail, this.productsInfo});
  String getProductInfo(String id, String attribute) {
    String output = '';
    productsInfo.forEach((product) {
      if (product.id == id) {
        switch (attribute) {
          case 'name':
            output = product.productName;
            break;
          case 'duration':
            output = product.processDuration;
            break;
          default:
        }
      }
    });
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage("assets/img/juice.png"),
          ),
          title: Text(getProductInfo(detail.productId, 'name')),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "Time to make: ${getProductInfo(detail.productId, 'duration')}"),
              Text("Amount: ${detail.amount}")
            ],
          ),
        );
      },
    );
  }
}
