import 'package:SPK_Coffee/Models/Order.dart';
import 'package:flutter/material.dart';

class CashProvider with ChangeNotifier {
  Order _order;
  List<ProductsInfo> _productsInfo = [];
  double _total = 0;
  void setTotal(double value) {
    _total = value;
    notifyListeners();
  }

  double getTotal() {
    return _total;
  }

  void calulateTotal() {
    if (_order != null && _order.details.length > 0) {
      _total = 0;
      _order.details.forEach((item) {
        _total += double.parse(item.price);
      });
      notifyListeners();
    }
  }

  void setCurrentOrder(Order value) {
    _order = value;
    notifyListeners();
  }

  void setProductsInfo(List<ProductsInfo> productsInfo) {
    _productsInfo.clear();
    productsInfo.forEach((infor) {
      _productsInfo.add(infor);
    });
    notifyListeners();
  }

  Order getCurrentOrder() {
    return _order;
  }

  List<ProductsInfo> getCurrentProductsInfo() {
    return _productsInfo;
  }
}
