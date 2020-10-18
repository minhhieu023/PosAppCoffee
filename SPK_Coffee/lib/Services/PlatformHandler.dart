import 'package:flutter/services.dart';

class PlatformHandler {
  PlatformHandler();
  static const platfom = MethodChannel('com.spkcoffee/notification');
  void makeNotification(String title, String content) {
    platfom.invokeMethod('createNotification',
        <String, dynamic>{'title': title, 'content': content});
  }
}
