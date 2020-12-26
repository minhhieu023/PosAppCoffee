import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/Models/ProviderModels/Calculate.dart';
import 'package:SPK_Coffee/Models/ProviderModels/CashScreenProvider.dart';
import 'package:SPK_Coffee/Models/ProviderModels/VoucherProvider.dart';
import 'package:SPK_Coffee/Utils/FormatString.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';

class DisplayDetailWid extends StatefulWidget {
  final double maxWidth;
  final double maxHeight;
  DisplayDetailWid({this.maxHeight, this.maxWidth});
  @override
  _DisplayDetailWidState createState() => _DisplayDetailWidState();
}

class _DisplayDetailWidState extends State<DisplayDetailWid> {
  List<ProductsInfo> productsInfo;
  String getProductName(String productId, List<ProductsInfo> productInfo) {
    for (var i = 0; i < productInfo.length; i++) {
      if (productInfo[i].id == productId) {
        return productInfo[i].productName;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Calculate calculate = Provider.of<Calculate>(context);
    CashProvider cashProvider = Provider.of<CashProvider>(context);
    Order order = cashProvider.getCurrentOrder();
    List<ProductsInfo> productInfo = cashProvider.getCurrentProductsInfo();
    return Column(
      children: [
        Expanded(
            flex: 7,
            child: Container(
              width: widget.maxWidth,
              height: widget.maxHeight,
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.black38)),
              child: cashProvider.getCurrentOrder() != null
                  ? (ListView.builder(
                      itemCount: order.details.length,
                      itemBuilder: (context, index) {
                        return Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                            ),
                            margin: EdgeInsets.all(5),
                            child: Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: [
                                TableRow(children: [
                                  Text(
                                    "${getProductName(order.details[index].productId, productInfo)} x${order.details[index].amount}",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "${formatMoney(order.details[index].price)} VNĐ",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  )
                                ])
                              ],
                            ));
                      },
                    ))
                  : Text("Choose"),
            )),
        Expanded(flex: 3, child: CalResultWid())
      ],
    );
  }
}

class CalResultWid extends StatefulWidget {
  @override
  _CalResultWidState createState() => _CalResultWidState();
}

class _CalResultWidState extends State<CalResultWid> {
  double fontSize = 15;
  var translator = {'#': new RegExp('/(\d)(?=(\d{3})+(?!\d))/g')};
  var controller = new MoneyMaskedTextController(precision: 3);

  TextEditingController textEditingController = TextEditingController();
  String calTotalWithDiscount(double total, double discount) {
    double percentRemain = (1 - discount / 100);
    return (total * percentRemain).toString();
  }

  @override
  Widget build(BuildContext context) {
    Calculate calculate = Provider.of<Calculate>(context);
    CashProvider cashProvider = Provider.of<CashProvider>(context);
    VoucherProvider voucherProvider = Provider.of<VoucherProvider>(context);
    String sum = calTotalWithDiscount(
      cashProvider.getTotal(),
      voucherProvider.getVoucher() == null
          ? 0
          : double.parse(voucherProvider.getVoucher().discount),
    );
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                "Amount tendered:",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            flex: 4,
                          ),
                          Expanded(
                            child: Container(
                              height: constraints.maxHeight * 0.25,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                              ),
                              child: Center(
                                child: Text(
                                  calculate.getSecondNum() == 0.0
                                      ? "0"
                                      : formatMoney(calculate
                                          .getSecondNum()
                                          .toString()
                                          .split(".")[0]),
                                  style: TextStyle(
                                      color: !calculate.isGreater()
                                          ? Colors.black
                                          : calculate.getSecondNum() == 0
                                              ? Colors.black
                                              : Colors.red),
                                ),
                              ),
                            ),
                            flex: 6,
                          )
                        ],
                      )),
                      Expanded(
                        //discount!
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Discount:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15),
                                ),
                              ),
                              flex: 4,
                            ),
                            Expanded(
                              child: Container(
                                height: constraints.maxHeight * 0.25,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5),
                                ),
                                child: Center(
                                  child: Text(voucherProvider.getVoucher() ==
                                          null
                                      ? "0"
                                      : "${voucherProvider.getVoucher().discount}%"),
                                ),
                              ),
                              flex: 6,
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "Total:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 15),
                            ),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Container(
                            height: fontSize + 10,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                            ),
                            child: Center(
                              child: Text("${formatMoney(sum.split('.')[0])}"),
                            ),
                          ),
                          flex: 7,
                        )
                      ],
                    )),
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "Change:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 15),
                            ),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Container(
                            height: fontSize + 10,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                            ),
                            child: Center(
                              child: Text(calculate.getResult()),
                            ),
                          ),
                          flex: 7,
                        )
                      ],
                    ))
                  ],
                ),
              )
            ],
          );
        },
      );
    } else {
      //Portrails
      return LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                "Amount tendered:",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            flex: 4,
                          ),
                          Expanded(
                            child: Container(
                              height: constraints.maxHeight * 0.25,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                              ),
                              child: Center(
                                  child: TextField(
                                style: TextStyle(
                                    color: !calculate.isGreater()
                                        ? Colors.black
                                        : calculate.getSecondNum() == 0
                                            ? Colors.black
                                            : Colors.red),
                                onChanged: (value) {
                                  print(value);
                                  calculate
                                      .setSecondNumber(double.parse(value));
                                  calculate.calculate();
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: controller,
                                keyboardType: TextInputType.number,
                              )),
                            ),
                            flex: 6,
                          )
                        ],
                      )),
                      Expanded(
                        //discount!
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Discount:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15),
                                ),
                              ),
                              flex: 4,
                            ),
                            Expanded(
                              child: Container(
                                height: constraints.maxHeight * 0.25,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5),
                                ),
                                child: Center(
                                  child: Text(voucherProvider.getVoucher() ==
                                          null
                                      ? "0"
                                      : "${voucherProvider.getVoucher().discount}%"),
                                ),
                              ),
                              flex: 6,
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "Total:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 15),
                            ),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Container(
                            height: fontSize + 10,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                            ),
                            child: Center(
                              child: Text("${formatMoney(sum.split('.')[0])}"),
                            ),
                          ),
                          flex: 7,
                        )
                      ],
                    )),
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "Change:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 15),
                            ),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Container(
                            height: fontSize + 10,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                            ),
                            child: Center(
                              child: Text(calculate.getResult()),
                            ),
                          ),
                          flex: 7,
                        )
                      ],
                    ))
                  ],
                ),
              )
            ],
          );
        },
      );
    }
  }
}

/***
 * 
 
 Text(
                                  calculate.getSecondNum() == 0.0
                                      ? "0"
                                      : formatMoney(calculate
                                          .getSecondNum()
                                          .toString()
                                          .split(".")[0]),
                                  style: TextStyle(
                                      color: !calculate.isGreater()
                                          ? Colors.black
                                          : calculate.getSecondNum() == 0
                                              ? Colors.black
                                              : Colors.red),
                                ),
 */
