import 'package:flutter/material.dart';

class Calculate with ChangeNotifier {
  double _firstNum = 0; //fir
  double _secondNum = 0;
  String _cal = ""; //Calculate
  String _result = "";
  double _finalResult = 0;
  double _discount = 0;
  bool _isSecond = false;
  RegExp regex = RegExp(r"([.]*0)(?!.*\d)");

  String getResult() {
    return _result;
  }

  void setDiscount(double value) {
    _discount = value;
    notifyListeners();
  }

  double getDiscount() {
    return _discount;
  }

  void setIsSecond(bool value) {
    _isSecond = value;
    notifyListeners();
  }

  bool isGreater() {
    return (_firstNum * (1 - _discount / 100)) > _secondNum ? true : false;
  }

  bool getIsSeccond() {
    return _isSecond;
  }

  void addSecond(double item) {
    if (_isSecond) {
      _secondNum = item;
      notifyListeners();
    }
  }

  void removeSecond() {
    String temp = _secondNum.toString();
    String finalTemp =
        temp.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");

    if (finalTemp.length > 1) {
      _secondNum = double.parse(finalTemp.substring(0, finalTemp.length - 1));
    } else if (finalTemp.length == 1) {
      _secondNum = 0;
    } else {
      _secondNum = 0;
    }
    notifyListeners();
  }

  void resetAll() {
    _firstNum = 0;
    _secondNum = 0;
    _cal = "";
    _result = "";
    _discount = 0;
    _finalResult = 0;
    notifyListeners();
  }

  String getCal() {
    return _cal;
  }

  void setCal(String value) {
    //dấu
    _cal = value;
    notifyListeners();
  }

  void resetCal() {
    _cal = "";
  }

  void calculate() {
    _cal = "-";
    if (!validate(_firstNum) || !validate(_secondNum)) {
      //check if 2 number are overflow
      _result = "Over flowed!";
    }

    switch (_cal) {
      case "":
        _result = "Pass in Equation";

        break;
      case "+":
        _result = (_secondNum + _firstNum).toString();
        break;
      case "-":
        _result = (_secondNum - (_firstNum * (1 - _discount / 100))).toString();
        break;
      case "X":
        _result = (_firstNum * _secondNum).toString();
        break;
      case "/":
        {
          if (_firstNum == 0) {
            _result = "Can't devide to 0";
          }
          _result = (_secondNum / _firstNum).toString();
        }
        break;
    }
    print(_result);
    notifyListeners();
  }

  void setFirstNumber(double value) {
    _firstNum = value;
    notifyListeners();
  }

  void setSecondNumber(double value) {
    _secondNum = value;
    notifyListeners();
  }

  double getFirstNum() {
    return _firstNum;
  }

  double getSecondNum() {
    return _secondNum;
  }

  double getFinalResult() {
    return _finalResult;
  }

  void setFinalResult(double value) {
    _finalResult = value;
    notifyListeners();
  }

  void addResult(String value) {
    _result += value;
    notifyListeners();
  }

  void setResult(String value) {
    _result = value;
    notifyListeners();
  }

  void clearResult() {
    _result = "";
    notifyListeners();
  }

  bool validate(double input) {
    if (input >= 10000000) {
      return false;
    }
    return true;
  }
}
