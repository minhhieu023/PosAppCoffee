class Category {
  String status;
  List<Data> data;

  Category({this.status, this.data});

  Category.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String id;
  String name;
  String createdAt;
  String updatedAt;
  List<Products> products;

  Data({this.id, this.name, this.createdAt, this.updatedAt, this.products});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
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
  Null popular;
  String processDuration;
  String mainImage;
  String createdAt;
  String updatedAt;
  String categoryId;

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
      this.categoryId});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    price = json['price'];
    hot = json['hot'];
    popular = json['popular'];
    processDuration = json['processDuration'];
    mainImage = json['mainImage'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    categoryId = json['categoryId'];
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
    return data;
  }
}
