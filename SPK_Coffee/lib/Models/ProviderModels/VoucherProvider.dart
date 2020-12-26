import 'package:SPK_Coffee/Models/Voucher.dart';
import 'package:SPK_Coffee/Services/Services.dart';
import 'package:flutter/material.dart';

class VoucherProvider with ChangeNotifier {
  Future<VoucherList> _fVoucher;
  Voucher _currentVoucher;
  VoucherProvider(this._fVoucher);
  Future<VoucherList> getFVoucher() {
    return _fVoucher;
  }

  void setCurrentVoucher(Voucher value) {
    _currentVoucher = value;
    notifyListeners();
  }

  Voucher getVoucher() {
    return _currentVoucher;
  }

  void revewVoucher() {
    _fVoucher = ServiceManager().getAllVoucher();
    notifyListeners();
  }

  void setFvoucher(Future<VoucherList> value) {
    _fVoucher = value;
    notifyListeners();
  }
}
