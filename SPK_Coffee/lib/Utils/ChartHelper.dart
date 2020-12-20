import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

BarChartGroupData makeGroupData(
  int x,
  double y, {
  bool isTouched = false,
  Color barColor = Colors.white,
  double width = 22,
  List<int> showTooltips = const [],
}) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        y: isTouched ? y + 1 : y,
        colors: isTouched ? [Colors.yellow] : [barColor],
        width: width,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          y: 20,
          colors: [Colors.black],
        ),
      ),
    ],
    showingTooltipIndicators: showTooltips,
  );
}

class BasicDateField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('Basic date field (${format.pattern})'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      ),
    ]);
  }
}
