import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'PlatformHandler.dart';

class SocketManagement {
  IO.Socket socket;
  PlatformHandler _platformHandler = new PlatformHandler();
  createSocketConnection() {
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
}
