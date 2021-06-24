import 'package:SPK_Coffee/Models/Shippers.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  List<Shippers> _shippers;
  void setShipper(List<Shippers> value) {
    _shippers = value;
    notifyListeners();
  }

  List<Shippers> get shipper => _shippers;
}
