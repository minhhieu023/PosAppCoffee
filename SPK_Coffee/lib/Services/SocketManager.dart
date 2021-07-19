import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'PlatformHandler.dart';

class SocketManagement {
  String _href = 'http://192.168.68.119:8000';
  IO.Socket socket;
  PlatformHandler _platformHandler = new PlatformHandler();
  createSocketConnection() {
    // http://192.168.0.199:8000
    // socket = IO.io('http://192.168.0.199:8000', <String, dynamic>{

    // http://103.153.73.107:8000
    socket = IO.io(_href, <String, dynamic>{
      'transports': ['websocket'],
    });
    if (!socket.connected) {
      print('connect fail');
    }
    socket.on('connect', (_) {
      print('connect');
    });
    socket.on('event', (data) => print(data));
    socket.on('notification', (data) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int priority = prefs.getInt("priority")==null? 4: prefs.getInt("priority");
      _platformHandler.makeNotification(data['title'], data['content'],
          priority: priority);
    });
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }

  //TODO: make call socket function

  makeMessage(String event, {dynamic data, bool isHaveData = false}) {
    socket = IO.io(_href, <String, dynamic>{
      'transports': ['websocket'],
    });
    if (!socket.connected) {
      print('connect fail');
    }
    if (isHaveData) {
      socket.emit(event, [data]);
    } else {
      socket.emit(event);
    }
  }

  addListener(String evenName, {Function() extensionFunc}) {
    socket = IO.io(_href, <String, dynamic>{
      'transports': ['websocket'],
    });
    if (!socket.connected) {
      print('connect fail');
    }
    socket.on('connect', (_) {
      print('connect');
    });
    socket.on(evenName, (data) {
      extensionFunc();
    });
  }
}
