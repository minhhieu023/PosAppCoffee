import 'package:SPK_Coffee/Models/Statistic.dart';
import 'package:SPK_Coffee/Utils/FormatString.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthChartWid extends StatefulWidget {
  final Future<Statistic> statisticMonth;
  final Function({String date}) getFutureStatic;
  final Function({String date}) getSelectedDate;
  MonthChartWid(
      {this.statisticMonth, this.getFutureStatic, this.getSelectedDate});
  @override
  _MonthChartWidState createState() => _MonthChartWidState();
}

class _MonthChartWidState extends State<MonthChartWid> {
  Future<Statistic> statistic;
  double point = 0;
  DateTime currentValue;
  final textController = TextEditingController();
  int setOffset = 0;
  List<Offset> offsetList = [Offset(5, 5), Offset(0, 0)];
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatisticFromParent();
  }

  double getAVGIncome(List<StatisticTotal> list) {
    double total = 0;
    for (var i = 0; i < list.length; i++) {
      total += double.parse(list[i].total);
    }
    return total / list.length;
  }

  double findMax(List<StatisticTotal> list) {
    double max = 0;
    list.forEach((element) {
      max =
          max > double.parse(element.total) ? max : double.parse(element.total);
    });
    return max;
  }

  String findDate(List<StatisticTotal> list, double total) {
    String date;
    list.forEach((element) {
      if (double.parse(element.total) == total) {
        date = element.date;
      }
    });
    return date;
  }

  double findMin(List<StatisticTotal> list) {
    double min = double.infinity;
    list.forEach((element) {
      min =
          min > double.parse(element.total) ? double.parse(element.total) : min;
    });
    return min;
  }

  getStatisticFromParent() {
    if (widget.statisticMonth != null) {
      statistic = widget.statisticMonth;
    }
  }

  @override
  Widget build(BuildContext context) {
    getStatisticFromParent();
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return FutureBuilder<Statistic>(
        future: statistic,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            if (snapshot.data.statisticTotal != null) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                      width: constraints.biggest.width * 0.7,
                      height: constraints.biggest.height * 0.5,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 6,
                              child: Center(
                                child: LineChart(
                                  LineChartData(
                                      backgroundColor:
                                          Color.fromRGBO(35, 45, 55, 1),
                                      axisTitleData: FlAxisTitleData(
                                          bottomTitle: AxisTitle(
                                              showTitle: true,
                                              titleText: "Date"),
                                          leftTitle: AxisTitle(
                                              showTitle: true,
                                              titleText: "Money(VNĐ)",
                                              margin: 25)),
                                      titlesData: FlTitlesData(
                                          bottomTitles: SideTitles(
                                            margin: 10,
                                            rotateAngle: 90,
                                            showTitles: true,
                                            getTitles: (value) {
                                              return snapshot
                                                  .data
                                                  .statisticTotal[value.toInt()]
                                                  .date;
                                            },
                                          ),
                                          leftTitles: SideTitles(
                                            margin: 25,
                                            showTitles: true,
                                            getTitles: (value) {
                                              if (value % 50000 == 0) {
                                                return formatMoney(
                                                    value.toInt().toString());
                                              }
                                              return "";
                                            },
                                          )),
                                      gridData: FlGridData(
                                        show: true,
                                        drawVerticalLine: true,
                                        getDrawingHorizontalLine: (value) {
                                          return FlLine(
                                            color: const Color(0xff37434d),
                                            strokeWidth: 1,
                                          );
                                        },
                                        getDrawingVerticalLine: (value) {
                                          return FlLine(
                                            color: const Color(0xff37434d),
                                            strokeWidth: 1,
                                          );
                                        },
                                      ),
                                      borderData: FlBorderData(
                                          show: true,
                                          border: Border.all(
                                              color: const Color(0xff37434d),
                                              width: 1)),
                                      minX: 0,
                                      maxX: double.parse(snapshot
                                              .data.statisticTotal.length
                                              .toString()) -
                                          1,
                                      minY: 0,
                                      maxY:
                                          findMax(snapshot.data.statisticTotal),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: snapshot.data.statisticTotal
                                              .map((e) {
                                            return FlSpot(
                                                double.parse(snapshot
                                                    .data.statisticTotal
                                                    .indexOf(e)
                                                    .toString()),
                                                double.parse(e.total));
                                          }).toList(),
                                          isCurved: true,
                                          colors: gradientColors,
                                          barWidth: 5,
                                          isStrokeCapRound: true,
                                          dotData: FlDotData(
                                            show: false,
                                          ),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            colors: gradientColors
                                                .map((color) =>
                                                    color.withOpacity(0.3))
                                                .toList(),
                                          ),
                                        )
                                      ]),
                                ),
                              )),
                          Expanded(
                              flex: 4,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                margin: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.05),
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
                                                left:
                                                    constraints.biggest.width *
                                                        0.01,
                                                right:
                                                    constraints.biggest.width *
                                                        0.01),
                                            width: constraints.biggest.width,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: constraints
                                                              .biggest.width *
                                                          0.1,
                                                      child: Text(
                                                        "Date:",
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      width: constraints
                                                              .biggest.width *
                                                          0.5,
                                                      child: TextField(
                                                        controller:
                                                            textController,
                                                        enabled: false,
                                                        autofocus: false,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 5),
                                                      child: IconButton(
                                                          icon: Icon(Icons
                                                              .calendar_today),
                                                          onPressed: () async {
                                                            DateTime
                                                                returnedData =
                                                                await showDatePicker(
                                                                    context:
                                                                        context,
                                                                    firstDate:
                                                                        DateTime(
                                                                            1900),
                                                                    initialDate:
                                                                        currentValue ??
                                                                            DateTime
                                                                                .now(),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2100));
                                                            textController
                                                                .text = returnedData
                                                                        .toString() ==
                                                                    null
                                                                ? ""
                                                                : returnedData
                                                                    .toString();
                                                            if (returnedData !=
                                                                null) {
                                                              widget.getFutureStatic(
                                                                  date: returnedData
                                                                      .toString());
                                                            }
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                                LayoutBuilder(
                                                  builder:
                                                      (context, constraints) {
                                                    return Container(
                                                      width: constraints
                                                              .biggest.width *
                                                          0.8,
                                                      height: constraints
                                                              .biggest.width *
                                                          0.8,
                                                      margin:
                                                          EdgeInsets.all(20),
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              offset: Offset(
                                                                  10, 10),
                                                              blurRadius: 0.2,
                                                              spreadRadius: 1,
                                                              color: Colors.pink
                                                                  .withOpacity(
                                                                      0.1))
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        border: Border.all(
                                                            width: 0.5),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Center(
                                                            child:
                                                                Text("Result"),
                                                          ),
                                                          Expanded(
                                                              child: Container(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Average income: ${formatMoney(getAVGIncome(snapshot.data.statisticTotal).toInt().toString())} VNĐ",
                                                                  softWrap:
                                                                      true,
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                          Expanded(
                                                              child: Container(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    "Highest income: ${formatMoney(findMax(snapshot.data.statisticTotal).toInt().toString())} VNĐ"),
                                                              ],
                                                            ),
                                                          )),
                                                          Expanded(
                                                              child: Container(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    "Highest income date: ${findDate(snapshot.data.statisticTotal, findMax(snapshot.data.statisticTotal))}"),
                                                              ],
                                                            ),
                                                          )),
                                                          Expanded(
                                                              child: Container(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    "Lowest income date: ${findDate(snapshot.data.statisticTotal, findMin(snapshot.data.statisticTotal))}"),
                                                              ],
                                                            ),
                                                          ))
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
                      ));
                },
              );
            } else {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // margin: EdgeInsets.only(
                  //     right: MediaQuery.of(context).size.width * 0.05),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: [
                      Text("Informations Board"),
                      Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    child: Text(
                                      "Date:",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: 5),
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
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
                                            widget.getFutureStatic(
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
                                    height: 300,
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
                                          child: Text(
                                            "Result",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                        Expanded(
                                            child: Center(
                                          child: Text(
                                            "No data to show!",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ))
                                      ],
                                    ),
                                  );
                                },
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              );
            }
          }
          return CircularProgressIndicator(
            backgroundColor: Colors.green,
          );
        },
      );
    } else {
      return FutureBuilder<Statistic>(
        future: statistic,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            if (snapshot.data.statisticTotal != null) {
              return Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: LineChart(
                            LineChartData(
                                backgroundColor: Color.fromRGBO(35, 45, 55, 1),
                                axisTitleData: FlAxisTitleData(
                                    bottomTitle: AxisTitle(
                                        showTitle: true, titleText: "Date"),
                                    leftTitle: AxisTitle(
                                        showTitle: true,
                                        titleText: "Money(VNĐ)",
                                        margin: 25)),
                                titlesData: FlTitlesData(
                                    bottomTitles: SideTitles(
                                      margin: 10,
                                      rotateAngle: 90,
                                      showTitles: true,
                                      getTitles: (value) {
                                        return snapshot.data
                                            .statisticTotal[value.toInt()].date;
                                      },
                                    ),
                                    leftTitles: SideTitles(
                                      margin: 25,
                                      showTitles: true,
                                      getTitles: (value) {
                                        if (value % 50000 == 0) {
                                          return formatMoney(
                                              value.toInt().toString());
                                        }
                                        return "";
                                      },
                                    )),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: true,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: const Color(0xff37434d),
                                      strokeWidth: 1,
                                    );
                                  },
                                  getDrawingVerticalLine: (value) {
                                    return FlLine(
                                      color: const Color(0xff37434d),
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(
                                        color: const Color(0xff37434d),
                                        width: 1)),
                                minX: 0,
                                maxX: double.parse(snapshot
                                        .data.statisticTotal.length
                                        .toString()) -
                                    1,
                                minY: 0,
                                maxY: findMax(snapshot.data.statisticTotal),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots:
                                        snapshot.data.statisticTotal.map((e) {
                                      return FlSpot(
                                          double.parse(snapshot
                                              .data.statisticTotal
                                              .indexOf(e)
                                              .toString()),
                                          double.parse(e.total));
                                    }).toList(),
                                    isCurved: true,
                                    colors: gradientColors,
                                    barWidth: 5,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: false,
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      colors: gradientColors
                                          .map(
                                              (color) => color.withOpacity(0.3))
                                          .toList(),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ),
                      //info board
                      Container(
                        width: MediaQuery.of(context).size.width,
                        // margin: EdgeInsets.only(
                        //     right: MediaQuery.of(context).size.width * 0.05),
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          children: [
                            Text("Informations Board"),
                            Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 50,
                                          child: Text(
                                            "Date:",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(left: 5),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
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
                                                        firstDate:
                                                            DateTime(1900),
                                                        initialDate:
                                                            currentValue ??
                                                                DateTime.now(),
                                                        lastDate:
                                                            DateTime(2100));
                                                textController.text =
                                                    returnedData.toString() ==
                                                            null
                                                        ? ""
                                                        : returnedData
                                                            .toString();
                                                if (returnedData != null) {
                                                  widget.getFutureStatic(
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
                                          width:
                                              constraints.biggest.width * 0.8,
                                          height:
                                              constraints.biggest.width * 0.8,
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
                                                child: Text(
                                                  "Result",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Average income: ${formatMoney(getAVGIncome(snapshot.data.statisticTotal).toInt().toString())} VNĐ",
                                                      softWrap: true,
                                                    ),
                                                  ],
                                                ),
                                              )),
                                              Expanded(
                                                  child: Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        "Highest income: ${formatMoney(findMax(snapshot.data.statisticTotal).toInt().toString())} VNĐ"),
                                                  ],
                                                ),
                                              )),
                                              Expanded(
                                                  child: Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        "Highest income date: ${findDate(snapshot.data.statisticTotal, findMax(snapshot.data.statisticTotal))}"),
                                                  ],
                                                ),
                                              )),
                                              Expanded(
                                                  child: Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        "Lowest income: ${formatMoney(findMin(snapshot.data.statisticTotal).toInt().toString())} VNĐ"),
                                                  ],
                                                ),
                                              )),
                                              Expanded(
                                                  child: Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        "Lowest income date: ${findDate(snapshot.data.statisticTotal, findMin(snapshot.data.statisticTotal))}"),
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                )),
                          ],
                        ),
                      )
                    ],
                  ));
            } else {
              return Center(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                // margin: EdgeInsets.only(
                //     right: MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [
                    Text("Informations Board"),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  child: Text(
                                    "Date:",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: 5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
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
                                          widget.getFutureStatic(
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
                                        child: Text(
                                          "Result",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Average income: 0 VNĐ",
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        child: Row(
                                          children: [
                                            Text("Highest income: 0 VNĐ"),
                                          ],
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        child: Row(
                                          children: [
                                            Text("Highest income date: "),
                                          ],
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        child: Row(
                                          children: [
                                            Text("Lowest income: 0 VNĐ"),
                                          ],
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                        child: Row(
                                          children: [
                                            Text("Lowest income date: "),
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
                        )),
                  ],
                ),
              ));
            }
          }
          return CircularProgressIndicator(
            backgroundColor: Colors.green,
          );
        },
      );
    }
  }
}
