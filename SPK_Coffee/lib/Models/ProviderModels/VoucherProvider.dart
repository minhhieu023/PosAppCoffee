import 'package:SPK_Coffee/Models/Voucher.dart';
import 'package:flutter/material.dart';

class VoucherProvider with ChangeNotifier {
  Future<VoucherList> _fVoucher;
  VoucherProvider(this._fVoucher);
  Future<VoucherList> getFVoucher() {
    return _fVoucher;
  }

  void setFvoucher(Future<VoucherList> value) {
    _fVoucher = value;
    notifyListeners();
  }
}
