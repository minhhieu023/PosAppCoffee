class Images {
  String id;
  String productImage;
  String createdAt;
  String updatedAt;
  String productId;

  Images(
      {this.id,
      this.productImage,
      this.createdAt,
      this.updatedAt,
      this.productId});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productImage = json['productImage'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productImage'] = this.productImage;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['productId'] = this.productId;
    return data;
  }
}
