import 'package:SPK_Coffee/Models/Product.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductInCartScreen extends StatefulWidget {
  final List<Products> listProduct;
  final Function addProductToCart;
  ProductInCartScreen({this.listProduct, this.addProductToCart, key})
      : super(key: key);

  @override
  _ProductInCartScreenState createState() => _ProductInCartScreenState();
}

class _ProductInCartScreenState extends State<ProductInCartScreen> {
  bool isRemoveProduct = false;

  void updateListProductWhenRemove() {
    setState(() {
      isRemoveProduct = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ordered Product List"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height:
                (MediaQuery.of(context).size.height - kToolbarHeight) * 0.88,
            // width: MediaQuery.of(context).size.width,
            child: Builder(
              builder: (context) {
                return ListView.builder(
                    itemCount: widget.listProduct.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductListView(
                          product: widget.listProduct[index],
                          updateProductAmount: widget.addProductToCart,
                          updateListProductWhenRemove:
                              updateListProductWhenRemove);
                    });
              },
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: RaisedButton(
                color: Colors.amber,
                onPressed: () {
                  print("OK");
                },
                child: Text("Thanh Toán"),
              ))
        ],
      ),
    );
  }
}

class ProductListView extends StatefulWidget {
  final Products product;
  final Function updateProductAmount;
  final Function updateListProductWhenRemove;
  ProductListView(
      {this.product,
      this.updateProductAmount,
      this.updateListProductWhenRemove,
      key})
      : super(key: key);

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  var productAmount = TextEditingController();
  String calMoney(String price, int amount) {
    int intPrice = int.parse(price);
    return (intPrice * amount).toString();
  }

  @override
  void initState() {
    productAmount.text = widget.product.amount.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blueAccent),
      ),
      child: Stack(
        children: [
          ListTile(
            title: Text(widget.product.productName),
            subtitle: Text(
              "Giá tiền: " + (widget.product.price),
            ),
          ), //Stack Product
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    widget.product.amount--;
                    productAmount.text = widget.product.amount.toString();
                    print(widget.product.amount.toString());
                    widget.updateProductAmount.call();
                    widget.updateListProductWhenRemove.call();
                  },
                  color: Colors.red,
                  icon: FaIcon(FontAwesomeIcons.minus),
                ),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: TextFormField(
                    controller: productAmount,
                    keyboardType: TextInputType.number,
                    //  / initialValue: widget.product.amount.toString(),
                    textAlign: TextAlign.center,
                    onEditingComplete: () => {
                      setState(() {
                        widget.product.amount = int.parse(productAmount.text);
                      })
                    },
                  ),
                ),
                IconButton(
                  color: Colors.green,
                  icon: FaIcon(FontAwesomeIcons.plus),
                  onPressed: () {
                    setState(() {
                      widget.product.amount++;
                      productAmount.text = widget.product.amount.toString();
                      print(widget.product.amount.toString());
                      widget.updateProductAmount.call();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
