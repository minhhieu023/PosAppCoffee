class OrderDetail {
  String id;
  String productId;
  int amount;
  String price;
  String createdAt;
  String updatedAt;
  String orderId;

  OrderDetail(
      {this.id,
      this.productId,
      this.amount,
      this.price,
      this.createdAt,
      this.updatedAt,
      this.orderId});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    amount = json['amount'];
    price = json['price'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['amount'] = this.amount;
    data['price'] = this.price;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['orderId'] = this.orderId;
    return data;
  }
}
