import 'package:SPK_Coffee/Models/Shippers.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:flutter/cupertino.dart';

import '../UserModel.dart';

class UserProvider with ChangeNotifier {
  List<Shippers> _shippers;
  UserModel user;
  void setShipper(List<Shippers> value) {
    _shippers = value;
    notifyListeners();
  }

  List<Shippers> get shipper => _shippers;
  Future<int> login(String userName, String passWord) async {
    this.user = await ServiceManager().loginEmployee(userName, passWord);
    if (user.status == "Success") {
      return 1;
    }
    return 1;
  }
}
