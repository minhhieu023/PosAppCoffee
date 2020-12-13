import 'package:SPK_Coffee/Models/ProviderModels/Calculate.dart';
import 'package:SPK_Coffee/Models/ProviderModels/VoucherProvider.dart';
import 'package:SPK_Coffee/Models/Voucher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DisyplayScreen/DisplayDetailWid.dart';

class CalculatePadWid extends StatefulWidget {
  CalculatePadWid();
  @override
  _CalculatePadWidState createState() => _CalculatePadWidState();
}

class _CalculatePadWidState extends State<CalculatePadWid> {
  @override
  Widget build(BuildContext context) {
    Calculate calculate = Provider.of<Calculate>(context);
    return Container(
        decoration: BoxDecoration(border: Border.all(width: 0.5)),
        child: Center(
          child: Column(
            children: [
              Expanded(child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: DisplayDetailWid(
                      maxHeight: constraints.maxHeight,
                      maxWidth: constraints.maxWidth,
                    ),
                  );
                },
              )),
              Expanded(
                  child: Container(
                child: Row(
                  children: [
                    Expanded(
                        child: Center(
                      child: PayWid(),
                    )),
                    Expanded(
                        flex: 2,
                        child: Container(
                          decoration:
                              BoxDecoration(border: Border.all(width: 0.5)),
                          child: NumPadWid(),
                        ))
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}

class NumPadWid extends StatefulWidget {
  @override
  _NumPadWidState createState() => _NumPadWidState();
}

class _NumPadWidState extends State<NumPadWid> {
  String inputNum = "";
  RegExp regex = RegExp(r"([.]*0)(?!.*\d)");
  bool isEquation(String eq) {
    if (eq == "+" || eq == "-" || eq == "X" || eq == "/") {
      return true;
    }
    return false;
  }

  void validateInput(String value) {
    if (value != "+" &&
        value != "-" &&
        value != "=" &&
        value != "X" &&
        value != "/" &&
        value != "DEL") {
      //allow input from number

      if (value == "." && inputNum.contains(".")) {
        return;
      } else if (value == "." && !inputNum.contains(".")) {
        inputNum += ".";
      } else {
        inputNum += value;
      }
    }
  }

  List<String> numPad = [
    "1",
    "2",
    "3",
    "DEL",
    "=",
    "4",
    "5",
    "6",
    "0",
    "C",
    "7",
    "8",
    "9"
  ];
  @override
  Widget build(BuildContext context) {
    Calculate calculate = Provider.of<Calculate>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          padding: EdgeInsets.only(
              left: constraints.maxWidth * 0.05,
              top: constraints.maxHeight * 0.05,
              bottom: constraints.maxHeight * 0.05,
              right: constraints.maxWidth * 0.05),
          primary: true,
          // physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 5,
          children: numPad.map((item) {
            return Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.3),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(2, 2),
                                  color: Colors.black45,
                                  spreadRadius: 0.4,
                                  blurRadius: 0.6)
                            ]),
                        width: constraints.biggest.width * 0.8,
                        height: constraints.biggest.height * 0.8,
                        child: FlatButton(
                            color: Colors.grey.withGreen(210).withOpacity(0.8),
                            onPressed: () {
                              print(item);
                              if (isEquation(item)) {
                                calculate.setCal(item);
                              } else if (item == "=") {
                                calculate.calculate();
                              } else if (item == "DEL") {
                                calculate.removeSecond();
                                inputNum = calculate
                                    .getSecondNum()
                                    .toString()
                                    .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
                              } else {
                                //add number
                                // calculate.addSecond(item)
                                if (calculate.getIsSeccond()) {
                                  validateInput(item);
                                }
                                calculate.addSecond(double.tryParse(inputNum));
                              }
                            },
                            child: item != "DEL"
                                ? Text(
                                    item,
                                    style: TextStyle(fontSize: 30),
                                  )
                                : Center(
                                    child: Icon(Icons.backspace),
                                  )),
                      ),
                    );
                  },
                )
              ],
            );
          }).toList(),
        );
      },
    );
  }
}

//Sub button, pay button:

class PayWid extends StatefulWidget {
  @override
  _PayWidState createState() => _PayWidState();
}

class _PayWidState extends State<PayWid> {
  String dropDownValue = "None";
  @override
  Widget build(BuildContext context) {
    VoucherProvider vouchers = Provider.of<VoucherProvider>(context);
    Future<VoucherList> fVoucher = vouchers.getFVoucher();
    return Container(
      child: Column(
        children: [
          Expanded(
              child: Container(
            child: Column(
              children: [
                Text("Voucher:"),
                // Expanded(
                //     child: FutureBuilder<VoucherList>(
                //   future: fVoucher,
                //   builder: (context, snapshot) {
                //     if (snapshot.hasData) {
                //       return DropdownButton(
                //         items: snapshot.data.vouchers.map((voucher) {
                //           return new DropdownMenuItem<String>(
                //             key: Key(voucher.id),
                //             value: voucher.id,
                //             child: Text(voucher.description),
                //           );
                //         }).toList(),
                //         onChanged: (value) {
                //           setState(() {
                //             dropDownValue = value;
                //           });
                //         },
                //         value: dropDownValue,
                //       );
                //     }
                //     return CircularProgressIndicator(
                //       backgroundColor: Colors.green,
                //     );
                //   },
                // ))
              ],
            ),
          )),
          Expanded(
              child: FlatButton(
            child: Text("Pay"),
            onPressed: () {
              print("pay");
            },
          ))
        ],
      ),
    );
  }
}
