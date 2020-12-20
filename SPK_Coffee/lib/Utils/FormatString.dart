import 'package:intl/intl.dart';

String sumTime(List<String> list, List<int> amountList) {
  int totalMinus = 0;
  int totalSecond = 0;
  for (var i = 0; i < list.length; i++) {
    totalMinus += int.parse(list[i].split(":")[0]) * amountList[i];
    totalSecond += int.parse(list[i].split(":")[1]) * amountList[i];
  }
  Duration time = Duration(minutes: totalMinus, seconds: totalSecond);
  format(time);
  return format(time);
}

format(Duration d) => d.toString().split('.').first;

String formatDateToString(String day) {
  return DateTime.parse(day).toString().split('.').first;
  // var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  // return DateFormat.d().parse(DateTime.parse(day).toString()).toString();
}

String formatMoney(String money) {
  NumberFormat oCcy = new NumberFormat("#,##0", "en_US");
  return oCcy.format(int.parse(money));
}

String getDate({String date}) {
  DateTime now = DateTime.now();
  if (date != null) {
    now = DateTime.parse(date);
  }
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  return formatted;
}

String getCustomDate() {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  return formatted;
}
