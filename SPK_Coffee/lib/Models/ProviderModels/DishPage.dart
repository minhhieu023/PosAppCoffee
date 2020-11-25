import 'package:flutter/material.dart';

class DishStore extends ChangeNotifier {
  bool _isSort = false;
  void toggleState() {
    _isSort = _isSort ? false : true;
    notifyListeners();
  }

  bool getIsSort() {
    return _isSort;
  }

  void setIsSort(bool value) {
    _isSort = value;
    notifyListeners();
  }
}
