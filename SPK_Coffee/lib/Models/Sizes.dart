class Sizes {
  String id;
  String productSize;
  String price;
  String createdAt;
  String updatedAt;
  String productId;

  Sizes(
      {this.id,
      this.productSize,
      this.price,
      this.createdAt,
      this.updatedAt,
      this.productId});

  Sizes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productSize = json['productSize'];
    price = json['price'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productSize'] = this.productSize;
    data['price'] = this.price;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['productId'] = this.productId;
    return data;
  }
}
