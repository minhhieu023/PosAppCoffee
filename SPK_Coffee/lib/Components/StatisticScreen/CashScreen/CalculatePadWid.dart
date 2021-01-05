import 'package:SPK_Coffee/Models/ProviderModels/Calculate.dart';
import 'package:SPK_Coffee/Models/ProviderModels/CashScreenProvider.dart';
import 'package:SPK_Coffee/Models/ProviderModels/VoucherProvider.dart';
import 'package:SPK_Coffee/Models/Voucher.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:SPK_Coffee/Services/SocketManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DisyplayScreen/DisplayDetailWid.dart';

class CalculatePadWid extends StatefulWidget {
  final Function() getReadyOrders;
  CalculatePadWid({this.getReadyOrders});
  @override
  _CalculatePadWidState createState() => _CalculatePadWidState();
}

class _CalculatePadWidState extends State<CalculatePadWid> {
  @override
  Widget build(BuildContext context) {
    // Calculate calculate = Provider.of<Calculate>(context);
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
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
                        child: PayWid(
                          getReadyOrders: widget.getReadyOrders,
                        ),
                      )),
                      Expanded(
                          flex: 2,
                          child: Stack(
                            overflow: Overflow.clip,
                            alignment: Alignment.center,
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return Container(
                                    width: constraints.maxWidth * 0.95,
                                    height: constraints.maxHeight * 0.95,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.5),
                                        borderRadius: BorderRadius.circular(45),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(1, 2),
                                              spreadRadius: 0.2,
                                              color: Colors.black87
                                                  .withOpacity(0.2),
                                              blurRadius: 0.8)
                                        ]),
                                  );
                                },
                              ),
                              Container(
                                child: NumPadWid(),
                              )
                            ],
                          ))
                    ],
                  ),
                ))
              ],
            ),
          ));
    } else {
      //portrails
      return Container(
          decoration: BoxDecoration(border: Border.all(width: 0.5)),
          child: Center(
            child: Column(
              children: [
                Expanded(
                    flex: 8,
                    child: LayoutBuilder(
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
                    flex: 2,
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                              child: Center(
                            child: PayWid(
                              getReadyOrders: widget.getReadyOrders,
                            ),
                          )),
                        ],
                      ),
                    ))
              ],
            ),
          ));
    }
  }
}

class NumPadWid extends StatefulWidget {
  @override
  _NumPadWidState createState() => _NumPadWidState();
}

class _NumPadWidState extends State<NumPadWid> {
  String inputNum = ""; //reset this var
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
                              if (calculate.getIsPay() == true) {
                                inputNum = "";
                                calculate.setIsPay(false);
                              }
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
  final Function() getReadyOrders;
  PayWid({this.getReadyOrders});
  @override
  _PayWidState createState() => _PayWidState();
}

class _PayWidState extends State<PayWid> {
  String dropDownValue = "None";
  int currentDrop = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Voucher getCurrentVoucher(List<Voucher> vouchers, String des) {
    Voucher target;
    vouchers.forEach((item) {
      if (item.description.contains(des)) {
        target = item;
      }
    });

    return target;
  }

  @override
  Widget build(BuildContext context) {
    VoucherProvider vouchers = Provider.of<VoucherProvider>(context);
    Future<VoucherList> fVoucher = vouchers.getFVoucher();
    Calculate calculate = Provider.of<Calculate>(context);
    CashProvider cashProvider = Provider.of<CashProvider>(context);
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: Column(
                children: [
                  Text("Voucher:"),
                  Expanded(
                      child: FutureBuilder<VoucherList>(
                    future: fVoucher,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<String> desList = [];
                        snapshot.data.vouchers.forEach((element) {
                          desList.add(element.description);
                        });
                        desList.add("None");
                        List<String> idList = [];
                        snapshot.data.vouchers.forEach((element) {
                          idList.add(element.id);
                        });
                        return Stack(
                          overflow: Overflow.clip,
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                              ),
                            ),
                            Positioned(
                                child: DropdownButton<String>(
                              value: dropDownValue,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropDownValue = newValue;
                                });
                                if (newValue != "None") {
                                  vouchers.setCurrentVoucher(getCurrentVoucher(
                                      snapshot.data.vouchers, newValue));
                                  calculate.setDiscount(double.parse(
                                      getCurrentVoucher(
                                              snapshot.data.vouchers, newValue)
                                          .discount));
                                } else {
                                  vouchers.setCurrentVoucher(null);
                                  calculate.setDiscount(0);
                                }
                                calculate.calculate();
                                print(dropDownValue);
                                // vouchers.setCurrentVoucher()
                              },
                              items: desList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ))
                          ],
                        );
                      }
                      return CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      );
                    },
                  ))
                ],
              ),
            )),
            Expanded(
              child: FlatButton(
                child: Text("Pay"),
                onPressed: () async {
                  print("pay");
                  int isSuccess = await ServiceManager().payOrder(
                      cashProvider.getCurrentOrder().id,
                      calculate.getSecondNum(),
                      double.parse(vouchers.getVoucher() == null
                          ? "0"
                          : vouchers.getVoucher().discount));
                  if (isSuccess == 1) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Payment successfully!"),
                    ));
                    widget.getReadyOrders.call();
                    SocketManagement().makeMessage("getUpdateDishKitchen");
                    SocketManagement().makeMessage("makeUpdateOrderScreen");
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Payment fail!"),
                    ));
                  }
                  calculate.setIsPay(true);
                  calculate.resetAll();
                },
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        child: Row(
          children: [
            Expanded(
                child: Container(
              child: Column(
                children: [
                  Text("Voucher:"),
                  Expanded(
                      child: FutureBuilder<VoucherList>(
                    future: fVoucher,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<String> desList = [];
                        snapshot.data.vouchers.forEach((element) {
                          desList.add(element.description);
                        });
                        desList.add("None");
                        List<String> idList = [];
                        snapshot.data.vouchers.forEach((element) {
                          idList.add(element.id);
                        });
                        return Stack(
                          overflow: Overflow.clip,
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                              ),
                            ),
                            Positioned(
                                child: DropdownButton<String>(
                              value: dropDownValue,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropDownValue = newValue;
                                });
                                if (newValue != "None") {
                                  vouchers.setCurrentVoucher(getCurrentVoucher(
                                      snapshot.data.vouchers, newValue));
                                  calculate.setDiscount(double.parse(
                                      getCurrentVoucher(
                                              snapshot.data.vouchers, newValue)
                                          .discount));
                                } else {
                                  vouchers.setCurrentVoucher(null);
                                  calculate.setDiscount(0);
                                }
                                calculate.calculate();
                                print(dropDownValue);
                                // vouchers.setCurrentVoucher()
                              },
                              items: desList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ))
                          ],
                        );
                      }
                      return CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      );
                    },
                  ))
                ],
              ),
            )),
            Expanded(
              child: FlatButton(
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Text("Pay"),
                onPressed: () async {
                  print("pay");
                  int isSuccess = await ServiceManager().payOrder(
                      cashProvider.getCurrentOrder().id,
                      calculate.getSecondNum(),
                      double.parse(vouchers.getVoucher() == null
                          ? "0"
                          : vouchers.getVoucher().discount));
                  if (isSuccess == 1) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Payment successfully!"),
                    ));
                    widget.getReadyOrders.call();
                    SocketManagement().makeMessage("getUpdateDishKitchen");
                    SocketManagement().makeMessage("makeUpdateOrderScreen");
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Payment fail!"),
                    ));
                  }
                  calculate.resetAll();
                },
              ),
            )
          ],
        ),
      );
    }
  }
}
