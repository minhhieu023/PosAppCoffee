class Statistic {
  List<StatisticTotal> statisticTotal;
  List<StatisticProducts> statisticProducts;

  Statistic({this.statisticTotal, this.statisticProducts});

  Statistic.fromJson(Map<String, dynamic> json) {
    if (json['statisticTotal'] != null) {
      statisticTotal = new List<StatisticTotal>();
      json['statisticTotal'].forEach((v) {
        statisticTotal.add(new StatisticTotal.fromJson(v));
      });
    }
    if (json['statisticProducts'] != null) {
      statisticProducts = new List<StatisticProducts>();
      json['statisticProducts'].forEach((v) {
        statisticProducts.add(new StatisticProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.statisticTotal != null) {
      data['statisticTotal'] =
          this.statisticTotal.map((v) => v.toJson()).toList();
    }
    if (this.statisticProducts != null) {
      data['statisticProducts'] =
          this.statisticProducts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatisticTotal {
  String total;
  String date;

  StatisticTotal({this.total, this.date});

  StatisticTotal.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['date'] = this.date;
    return data;
  }
}

class StatisticProducts {
  String id;
  String productname;
  String total;
  String productdescription;
  String totalprice;

  StatisticProducts(
      {this.id,
      this.productname,
      this.total,
      this.productdescription,
      this.totalprice});

  StatisticProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productname = json['productname'];
    total = json['total'];
    productdescription = json['productdescription'];
    totalprice = json['totalprice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productname'] = this.productname;
    data['total'] = this.total;
    data['productdescription'] = this.productdescription;
    data['totalprice'] = this.totalprice;
    return data;
  }
}
