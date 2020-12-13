class VoucherList {
  List<Voucher> vouchers;

  VoucherList({this.vouchers});

  VoucherList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      vouchers = new List<Voucher>();
      json['data'].forEach((v) {
        vouchers.add(new Voucher.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vouchers != null) {
      data['data'] = this.vouchers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Voucher {
  String id;
  String description;
  String discount;
  String title;
  String stateDate;
  String endDate;
  String createdAt;
  String updatedAt;

  Voucher(
      {this.id,
      this.description,
      this.discount,
      this.title,
      this.stateDate,
      this.endDate,
      this.createdAt,
      this.updatedAt});

  Voucher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    discount = json['discount'];
    title = json['title'];
    stateDate = json['stateDate'];
    endDate = json['endDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['discount'] = this.discount;
    data['title'] = this.title;
    data['stateDate'] = this.stateDate;
    data['endDate'] = this.endDate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
