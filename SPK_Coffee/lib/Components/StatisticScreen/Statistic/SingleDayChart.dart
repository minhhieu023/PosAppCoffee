import 'package:SPK_Coffee/Utils/ChartHelper.dart';
import 'package:SPK_Coffee/Utils/FormatString.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SingleDayChartWid extends StatefulWidget {
  final Map<String, dynamic> drawInfo;
  final Function({String date}) getSelectedDate;
  SingleDayChartWid({this.drawInfo, this.getSelectedDate});
  @override
  _SingleDayChartWidState createState() => _SingleDayChartWidState();
}

class _SingleDayChartWidState extends State<SingleDayChartWid> {
  int touchedIndex;
  Map<String, dynamic> drawInfo;
  DateTime currentValue;
  final textController = TextEditingController();
  List<BarChartGroupData> showingGroups() => List.generate(2, (i) {
        switch (i) {
          case 0:
            return makeGroupData(
                0, double.parse(drawInfo['totalEarnYesterday'].toString()),
                barColor: Colors.green, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(
                1, double.parse(drawInfo['totalEarnToday'].toString()),
                barColor: Colors.green, isTouched: i == touchedIndex);
          default:
            return null;
        }
      });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getDrawInfo() {
    drawInfo = widget.drawInfo;
  }

  @override
  Widget build(BuildContext context) {
    getDrawInfo();
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return Container(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 6,
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    //chart
                    child: BarChart(BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                              tooltipBgColor: Colors.blueGrey,
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                String date;
                                switch (group.x.toInt()) {
                                  case 0:
                                    date = 'Yesterday';
                                    break;
                                  case 1:
                                    date = 'Today';
                                    break;
                                }
                                return BarTooltipItem(
                                    date + '\n' + (rod.y - 1).toString(),
                                    TextStyle(color: Colors.yellow));
                              }),
                          touchCallback: (barTouchResponse) {
                            setState(() {
                              if (barTouchResponse.spot != null &&
                                  barTouchResponse.touchInput is! FlPanEnd &&
                                  barTouchResponse.touchInput
                                      is! FlLongPressEnd) {
                                touchedIndex =
                                    barTouchResponse.spot.touchedBarGroupIndex;
                              } else {
                                touchedIndex = -1;
                              }
                            });
                          },
                        ),
                        backgroundColor: Color.fromRGBO(76, 96, 122, 1),
                        axisTitleData: FlAxisTitleData(
                            leftTitle: AxisTitle(
                                margin: 25,
                                showTitle: true,
                                titleText: "Money(VNĐ)"),
                            bottomTitle: AxisTitle(
                                showTitle: true,
                                titleText: "Money",
                                textStyle: TextStyle())),
                        titlesData: FlTitlesData(
                            leftTitles: SideTitles(
                              showTitles: true,
                              getTitles: (double value) {
                                switch (value.toInt()) {
                                  case 0:
                                    return '0';
                                  case 50000:
                                    return value.toString();
                                  case 100000:
                                    return value.toString();
                                  case 150000:
                                    return value.toString();
                                  case 200000:
                                    return value.toString();
                                  case 300000:
                                    return value.toString();
                                  case 300000:
                                    return value.toString();
                                  case 500000:
                                    return value.toString();
                                  case 1000000:
                                    return value.toString();
                                  case 2000000:
                                    return value.toString();
                                  case 5000000:
                                    return value.toString();
                                  case 10000000:
                                    return value.toString();
                                  default:
                                    return '';
                                }
                              },
                            ),
                            bottomTitles: SideTitles(
                              getTitles: (double value) {
                                switch (value.toInt()) {
                                  case 0:
                                    return '${drawInfo["yesterday"]}';
                                  case 1:
                                    return '${drawInfo["today"]}';
                                  default:
                                    return '';
                                }
                              },
                              showTitles: true,
                            )),
                        borderData: FlBorderData(
                            border: Border.all(width: 1), show: true),
                        gridData: FlGridData(
                          show: true,
                        ),
                        barGroups: showingGroups())),
                  ),
                )),
            //infor board
            Expanded(
                flex: 4,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: [
                      Text("Informations Board"),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                              margin: EdgeInsets.only(
                                  left: constraints.biggest.width * 0.01,
                                  right: constraints.biggest.width * 0.01),
                              width: constraints.biggest.width,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: constraints.biggest.width * 0.1,
                                        child: Text(
                                          "Date:",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(left: 5),
                                        width: constraints.biggest.width * 0.5,
                                        child: TextField(
                                          controller: textController,
                                          enabled: false,
                                          autofocus: false,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 5),
                                        child: IconButton(
                                            icon: Icon(Icons.calendar_today),
                                            onPressed: () async {
                                              DateTime returnedData =
                                                  await showDatePicker(
                                                      context: context,
                                                      firstDate: DateTime(1900),
                                                      initialDate:
                                                          currentValue ??
                                                              DateTime.now(),
                                                      lastDate: DateTime(2100));
                                              textController.text =
                                                  returnedData.toString() ==
                                                          null
                                                      ? ""
                                                      : returnedData.toString();
                                              if (returnedData != null) {
                                                widget.getSelectedDate(
                                                    date: returnedData
                                                        .toString());
                                              }
                                            }),
                                      ),
                                    ],
                                  ),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Container(
                                        width: constraints.biggest.width * 0.8,
                                        height: constraints.biggest.width * 0.8,
                                        margin: EdgeInsets.all(20),
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(10, 10),
                                                blurRadius: 0.2,
                                                spreadRadius: 1,
                                                color: Colors.pink
                                                    .withOpacity(0.1))
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(width: 0.5),
                                        ),
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Text("Result"),
                                            ),
                                            Expanded(
                                                child: Container(
                                              child: Row(
                                                children: [
                                                  Text("Yesterday income: "),
                                                  Text(
                                                      "${formatMoney(drawInfo['totalEarnYesterday'].toString())} VNĐ")
                                                ],
                                              ),
                                            )),
                                            Expanded(
                                                child: Container(
                                              child: Row(
                                                children: [
                                                  Text("Today income: "),
                                                  Text(
                                                    "${formatMoney(drawInfo['totalEarnToday'].toString())} VNĐ",
                                                    softWrap: true,
                                                  )
                                                ],
                                              ),
                                            )),
                                            Expanded(
                                                child: Container(
                                              child: Row(
                                                children: [
                                                  Text("Difference: "),
                                                  Text(
                                                    "${drawInfo['totalEarnYesterday'] - drawInfo['totalEarnToday']} VNĐ",
                                                    softWrap: true,
                                                  )
                                                ],
                                              ),
                                            )),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ));
                        },
                      ),
                    ],
                  ),
                ))
          ],
        ),
      );
    } else {
      //portrails:
      return Container(
        padding: EdgeInsets.only(top: 20),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 20),
              child: Center(
                //chart
                child: BarChart(BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.blueGrey,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            String date;
                            switch (group.x.toInt()) {
                              case 0:
                                date = 'Yesterday';
                                break;
                              case 1:
                                date = 'Today';
                                break;
                            }
                            return BarTooltipItem(
                                date + '\n' + (rod.y - 1).toString(),
                                TextStyle(color: Colors.yellow));
                          }),
                      touchCallback: (barTouchResponse) {
                        setState(() {
                          if (barTouchResponse.spot != null &&
                              barTouchResponse.touchInput is! FlPanEnd &&
                              barTouchResponse.touchInput is! FlLongPressEnd) {
                            touchedIndex =
                                barTouchResponse.spot.touchedBarGroupIndex;
                          } else {
                            touchedIndex = -1;
                          }
                        });
                      },
                    ),
                    backgroundColor: Color.fromRGBO(76, 96, 122, 1),
                    axisTitleData: FlAxisTitleData(
                        leftTitle: AxisTitle(
                            margin: 25,
                            showTitle: true,
                            titleText: "Money(VNĐ)"),
                        bottomTitle: AxisTitle(
                            showTitle: true,
                            titleText: "Money",
                            textStyle: TextStyle())),
                    titlesData: FlTitlesData(
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return '0';
                              case 50000:
                                return value.toString();
                              case 100000:
                                return value.toString();
                              case 150000:
                                return value.toString();
                              case 200000:
                                return value.toString();
                              case 300000:
                                return value.toString();
                              case 300000:
                                return value.toString();
                              case 500000:
                                return value.toString();
                              case 1000000:
                                return value.toString();
                              case 2000000:
                                return value.toString();
                              case 5000000:
                                return value.toString();
                              case 10000000:
                                return value.toString();
                              default:
                                return '';
                            }
                          },
                        ),
                        bottomTitles: SideTitles(
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return '${drawInfo["yesterday"]}';
                              case 1:
                                return '${drawInfo["today"]}';
                              default:
                                return '';
                            }
                          },
                          showTitles: true,
                        )),
                    borderData:
                        FlBorderData(border: Border.all(width: 1), show: true),
                    gridData: FlGridData(
                      show: true,
                    ),
                    barGroups: showingGroups())),
              ),
            ),
            //infor board
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.05),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                children: [
                  Text("Informations Board"),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                          margin: EdgeInsets.only(
                              left: constraints.biggest.width * 0.01,
                              right: constraints.biggest.width * 0.01),
                          width: constraints.biggest.width,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: constraints.biggest.width * 0.1,
                                    child: Text(
                                      "Date:",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: 5),
                                    width: constraints.biggest.width * 0.5,
                                    child: TextField(
                                      controller: textController,
                                      enabled: false,
                                      autofocus: false,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child: IconButton(
                                        icon: Icon(Icons.calendar_today),
                                        onPressed: () async {
                                          DateTime returnedData =
                                              await showDatePicker(
                                                  context: context,
                                                  firstDate: DateTime(1900),
                                                  initialDate: currentValue ??
                                                      DateTime.now(),
                                                  lastDate: DateTime(2100));
                                          textController.text =
                                              returnedData.toString() == null
                                                  ? ""
                                                  : returnedData.toString();
                                          if (returnedData != null) {
                                            widget.getSelectedDate(
                                                date: returnedData.toString());
                                          }
                                        }),
                                  ),
                                ],
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return Container(
                                    width: constraints.biggest.width * 0.8,
                                    height: constraints.biggest.width * 0.8,
                                    margin: EdgeInsets.all(20),
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(10, 10),
                                            blurRadius: 0.2,
                                            spreadRadius: 1,
                                            color: Colors.pink.withOpacity(0.1))
                                      ],
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(width: 0.5),
                                    ),
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text("Result"),
                                        ),
                                        Expanded(
                                            child: Container(
                                          child: Row(
                                            children: [
                                              Text("Yesterday income: "),
                                              Text(
                                                  "${formatMoney(drawInfo['totalEarnYesterday'].toString())} VNĐ")
                                            ],
                                          ),
                                        )),
                                        Expanded(
                                            child: Container(
                                          child: Row(
                                            children: [
                                              Text("Today income: "),
                                              Text(
                                                "${formatMoney(drawInfo['totalEarnToday'].toString())} VNĐ",
                                                softWrap: true,
                                              )
                                            ],
                                          ),
                                        )),
                                        Expanded(
                                            child: Container(
                                          child: Row(
                                            children: [
                                              Text("Difference: "),
                                              Text(
                                                "${drawInfo['totalEarnYesterday'] - drawInfo['totalEarnToday']} VNĐ",
                                                softWrap: true,
                                              )
                                            ],
                                          ),
                                        )),
                                      ],
                                    ),
                                  );
                                },
                              )
                            ],
                          ));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
  }
}
