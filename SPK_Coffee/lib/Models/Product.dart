import 'package:SPK_Coffee/Models/Image.dart';
import 'package:SPK_Coffee/Models/Sizes.dart';

class ListProduct {
  List<Products> listProduct;

  ListProduct({this.listProduct});

  ListProduct.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      listProduct = new List<Products>();
      json['data'].forEach((v) {
        listProduct.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listProduct != null) {
      data['data'] = this.listProduct.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String id;
  String productName;
  String productDescription;
  String price;
  String hot;
  int amount;
  String state;
  String popular;
  String processDuration;
  String mainImage;
  String createdAt;
  String updatedAt;
  String categoryId;
  List<Sizes> sizes;
  List<Images> images;
  String productId;

  Products(
      {this.id,
      this.productName,
      this.productDescription,
      this.price,
      this.hot,
      this.popular,
      this.processDuration,
      this.mainImage,
      this.createdAt,
      this.updatedAt,
      this.categoryId,
      this.sizes,
      this.images,
      this.amount,
      this.productId,
      this.state});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    productDescription = json['productDescription'];

    price = json['price'];
    hot = json['hot'];
    popular = json['popular'] == 'true' ? 'true' : 'false';
    processDuration = json['processDuration'];
    amount = json['amount'];
    mainImage = json['mainImage'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    categoryId = json['categoryId'];
    state = json['state'];
    if (json['sizes'] != null) {
      sizes = new List<Sizes>();
      json['sizes'].forEach((v) {
        sizes.add(new Sizes.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productName'] = this.productName;
    data['productDescription'] = this.productDescription;

    data['price'] = this.price;
    data['hot'] = this.hot;
    data['popular'] = this.popular;
    data['processDuration'] = this.processDuration;
    data['mainImage'] = this.mainImage;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['categoryId'] = this.categoryId;
    if (this.sizes != null) {
      data['sizes'] = this.sizes.map((v) => v.toJson()).toList();
    }
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['amount'] = this.amount;
    data['productId'] = this.productId;
    return data;
  }
}
