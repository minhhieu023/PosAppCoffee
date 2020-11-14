import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'PlatformHandler.dart';

class SocketManagement {
  IO.Socket socket;
  PlatformHandler _platformHandler = new PlatformHandler();
  createSocketConnection() {
    // http://caffeeshopbackend.herokuapp.com
    socket = IO.io('http://caffeeshopbackend.herokuapp.com', <String, dynamic>{
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
  makeMessage(String event) {
    socket = IO.io('http://caffeeshopbackend.herokuapp.com', <String, dynamic>{
      'transports': ['websocket'],
    });
    if (!socket.connected) {
      print('connect fail');
    }
    socket.emit(event);
  }

  addListener(String evenName, {Function() extensionFunc}) {
    socket = IO.io('http://caffeeshopbackend.herokuapp.com', <String, dynamic>{
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
