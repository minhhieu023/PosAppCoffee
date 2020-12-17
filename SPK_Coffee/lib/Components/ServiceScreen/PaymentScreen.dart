import 'dart:ffi';

import 'package:SPK_Coffee/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final List<Products> listProduct;
  PaymentScreen({this.listProduct, key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isClick;
  bool isCash;
  int total;
  TextEditingController textEditingController = TextEditingController();
  void chooseOptionPayment() {
    setState(() {
      isCash ? isCash = false : isCash = true;
      isClick ? isClick = false : isClick = true;
    });
  }

  @override
  void initState() {
    textEditingController.text = "0";
    isClick = true;
    isCash = true;
    total = 0;
    widget.listProduct.forEach((element) {
      total += element.amount * int.parse(element.price);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A3-Payment"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            shadowColor: Colors.black,
            child: ListTile(
                leading: Text("Provisional"), trailing: Text(total.toString())),
          ),
          Card(
            shadowColor: Colors.black,
            child: ListTile(
              leading: Text("Discout (%)"),
              trailing: SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                child: TextFormField(
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "%",
                  ),
                ),
              ),
            ),
          ),
          Card(
            shadowColor: Colors.black,
            child: ListTile(
              leading: Text(
                "Total",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              trailing: Text(
                (total * (100 - int.parse(textEditingController.text)) / 100)
                    .toStringAsFixed(0)
                    .toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - kToolbarHeight) * 0.1,
            // width: (MediaQuery.of(context).size.width),
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      chooseOptionPayment();
                    },
                    child: Card(
                      color: isCash && isClick ? Colors.amber : null,
                      shadowColor: Colors.black,
                      child: Container(
                        height: (MediaQuery.of(context).size.height -
                                kToolbarHeight) *
                            0.09,
                        width: (MediaQuery.of(context).size.width) / 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: FaIcon(FontAwesomeIcons.coins),
                            ),
                            Text("Cash")
                          ],
                        ),
                      ),
                      // footer: Text("Cash"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      chooseOptionPayment();
                    },
                    child: Card(
                      color: isCash && isClick ? null : Colors.amber,
                      shadowColor: Colors.black,
                      child: Container(
                        height: (MediaQuery.of(context).size.height -
                                kToolbarHeight) *
                            0.09,
                        width: (MediaQuery.of(context).size.width) / 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: FaIcon(FontAwesomeIcons.creditCard),
                            ),
                            Text("Credit Card")
                          ],
                        ),
                      ),
                    ),
                    // footer: Text("Cash"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton(
          onPressed: () {
            print("Payment");
          },
          color: Colors.green,
          child: Text("Payment"),
        ),
      ),
    );
  }
}
