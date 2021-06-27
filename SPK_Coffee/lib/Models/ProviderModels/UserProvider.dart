import 'package:SPK_Coffee/Models/EmployeeInfo.dart';
import 'package:SPK_Coffee/Models/Shippers.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  CurrentUser _currentUser;
  CurrentUser get currentUser => _currentUser;
  void setCurrentUser(CurrentUser value) {
    _currentUser = value;
    notifyListeners();
  }

  List<Shippers> _shippers;
  void setShipper(List<Shippers> value) {
    _shippers = value;
    notifyListeners();
  }

  List<Shippers> get shipper => _shippers;
}
