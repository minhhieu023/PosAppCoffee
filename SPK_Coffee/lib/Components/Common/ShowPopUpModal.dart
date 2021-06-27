import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

Future<void> showFailDialog(BuildContext context,
    {@required String title, @required String message, int displayTime}) async {
  ProgressDialog errorDialog = ProgressDialog(
    context,
    defaultLoadingWidget: Text(""),
    dialogStyle: DialogStyle(titleDivider: true),
    title: Text(
      title,
      textAlign: TextAlign.center,
    ),
    message: Container(
      child: Column(
        children: [
          Image.asset("assets/img/62484-error-mark.gif"),
          Text(
            message,
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    ),
  );
  errorDialog.show();
  await Future.delayed(
    Duration(
      seconds: displayTime == null ? 3 : displayTime,
    ),
  );
  errorDialog.dismiss();
}

Future<void> showSuccessDialog(BuildContext context,
    {@required String title,
    @required String message,
    int displayTime,
    String imagePath}) async {
  ProgressDialog successDialog = ProgressDialog(
    context,
    defaultLoadingWidget: Text(""),
    dialogStyle: DialogStyle(titleDivider: true),
    title: Text(
      title,
      textAlign: TextAlign.center,
    ),
    message: Container(
      child: Column(
        children: [
          Image.asset(
              imagePath == null ? "assets/img/61434-success.gif" : imagePath),
          Text(
            message,
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    ),
  );
  successDialog.show();
  await Future.delayed(
    Duration(
      seconds: displayTime == null ? 3 : displayTime,
    ),
  );
  successDialog.dismiss();
}

Future<bool> showConfirmDialog(BuildContext context,
    {String title, String content}) async {
  return await NDialog(
    dialogStyle: DialogStyle(titleDivider: true),
    title: Text(
      title,
      textAlign: TextAlign.center,
    ),
    content: Text(
      content,
      textAlign: TextAlign.justify,
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context, false);
        },
        child: Text("Cancel", style: TextStyle(color: Colors.red)),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context, true);
        },
        child: Text("Ok", style: TextStyle(color: Colors.green)),
      )
    ],
  ).show(context);
}
