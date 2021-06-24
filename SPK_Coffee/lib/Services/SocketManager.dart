import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'PlatformHandler.dart';

class SocketManagement {
  String _href = 'http://192.168.1.6:8000';
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
    socket.on('notification', (data) {
      _platformHandler.makeNotification(data['title'], data['content']);
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
