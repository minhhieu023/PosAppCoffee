import 'dart:developer';

import 'package:SPK_Coffee/Models/OrderList.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:flutter/material.dart';

class UpdateOrderProvider with ChangeNotifier {
  Future<OrderList> _currentOrder = ServiceManager().getReadyOrders();
  Future<OrderList> getCurrentOrder() {
    return _currentOrder;
  }

  void resetCurrentOrder() {
    _currentOrder = ServiceManager().getReadyOrders();
    notifyListeners();
  }
}
