import 'package:SPK_Coffee/Components/StatisticScreen/Statistic/MonthChart.dart';
import 'package:SPK_Coffee/Models/Statistic.dart';
import 'package:SPK_Coffee/Utils/ChartHelper.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:SPK_Coffee/Utils/FormatString.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'SingleDayChart.dart';

class MainStatisticsNav extends StatefulWidget {
  @override
  _MainStatisticsNavState createState() => _MainStatisticsNavState();
}

class _MainStatisticsNavState extends State<MainStatisticsNav> {
  Future<Map<String, dynamic>> list;
  Future<Statistic> statisticMonth;
  List<String> pageTitle = ["Daily Income", "Monthly Income"];
  int currentSelectedTitle = 0;
  final pageController = PageController(
    initialPage: 0,
  );
  DateTime currentValue;
  String customDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodayEarn();
    getCustomStatisticMonth();
  }

  void getTodayEarn({String date}) {
    setState(() {
      list = new ServiceManager().getOneDayEarning(getDate(date: date));
    });
  }

  void getCustomStatisticMonth({String date}) {
    setState(() {
      statisticMonth =
          new ServiceManager().getStatisticMonth(getDate(date: date));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle[currentSelectedTitle]),
        actions: [IconButton(icon: Icon(Icons.select_all), onPressed: null)],
      ),
      body: PageView(
        onPageChanged: (value) {
          setState(() {
            currentSelectedTitle = value;
          });
        },
        controller: pageController,
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: list,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleDayChartWid(
                  drawInfo: snapshot.data,
                  getSelectedDate: getTodayEarn,
                );
              } else {
                return CircularProgressIndicator(
                  backgroundColor: Colors.green,
                );
              }
            },
          ),
          MonthChartWid(
            statisticMonth: statisticMonth,
            getFutureStatic: getCustomStatisticMonth,
            getSelectedDate: getTodayEarn,
          )
        ],
      ),
    );
  }
}
