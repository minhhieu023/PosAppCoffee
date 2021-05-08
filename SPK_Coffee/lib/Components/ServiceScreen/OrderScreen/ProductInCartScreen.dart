import 'package:SPK_Coffee/Components/ServiceScreen/PaymentScreen.dart';
import 'package:SPK_Coffee/Models/CoffeeTable.dart';
import 'package:SPK_Coffee/Models/Product.dart';
import 'package:SPK_Coffee/Services/SocketManager.dart';
import 'package:SPK_Coffee/Utils/StaticValue.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductInCartScreen extends StatefulWidget {
  CoffeeTable table;
  List<Products> listProduct;
  Function addProductToCart;
  Function setStateWhenHaveOrder;
  bool haveOrder;
//  String totalMoney;
  ProductInCartScreen(
      {this.haveOrder,
      this.setStateWhenHaveOrder,
      this.table,
      this.listProduct,
      this.addProductToCart,
      key})
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

  void setStateCalMoney() {
    setState(() {
      callMoney();
    });
  }

  String callMoney() {
    int total = 0;
    widget.listProduct.forEach((element) {
      print(total);
      print(element.amount);
      print(element.price);
      if (widget.haveOrder == false)
        total += (element.amount * int.parse(element.price));
      else
        total += (int.parse(element.price));
    });
    return total.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    callMoney();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Vo" + "${widget.haveOrder}");
    return Container(
        height: (MediaQuery.of(context).size.height - kToolbarHeight) * 0.97,
        child: Column(
          children: [
            // Expanded(
            //   flex: 2,
            //   // height:
            //   //(MediaQuery.of(context).size.height - kToolbarHeight) * 0.017,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     crossAxisAlignment: CrossAxisAlignment.baseline,
            //     children: [Text("Name"), Text("Amount"), Text("State")],
            //   ),
            // ),
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
                            productImage: widget.listProduct[index].mainImage,
                            updateListProductWhenRemove:
                                updateListProductWhenRemove,
                            updateTotalMoney: setStateCalMoney,
                            haveOrder: widget.haveOrder);
                      });
                },
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: RaisedButton(
                  color: Colors.amber,
                  onPressed: () {
                    SocketManagement _socketManagement = new SocketManagement();

                    _socketManagement.makeMessage("NotifyCashier",
                        isHaveData: true,
                        data: "Order ${widget.table.name} need to pay!");

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => PaymentScreen(
                    //               listProduct: widget.listProduct,
                    //               //  addProductToCart:
                    //               //   updateAmountProduct,
                    //             )));
                  },
                  child: Text(callMoney()),
                ))
          ],
        ));
  }
}

class ProductListView extends StatefulWidget {
  final String productImage;
  final Products product;
  final Function updateProductAmount;
  final Function updateListProductWhenRemove;
  final Function updateTotalMoney;
  bool haveOrder;
  ProductListView(
      {this.product,
      this.productImage,
      this.updateProductAmount,
      this.updateListProductWhenRemove,
      this.updateTotalMoney,
      this.haveOrder,
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
    // print(widget.product.amount.toString());
    productAmount.text = widget.product.amount.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.product.price);
    print(widget.product.productName);
    print(widget.haveOrder);
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blueAccent),
      ),
      child: Stack(
        children: [
          ListTile(
            leading: widget.productImage != null
                ? Image.network(StaticValue.svPath + '${widget.productImage}',
                    fit: BoxFit.fill)
                : Icon(FontAwesomeIcons.rProject),
            title: Text(
              widget.product.productName,
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              "Size: M",
            ),
            trailing: Text(widget.product.state != null
                ? widget.product.state.toString()
                : " "),
          ), //Stack Product
          widget.haveOrder
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // IconButton(
                      //   onPressed: () {
                      //     widget.product.amount--;
                      //     productAmount.text = widget.product.amount.toString();
                      //     print(widget.product.amount.toString());
                      //     widget.updateProductAmount.call();
                      //     widget.updateTotalMoney.call();
                      //     widget.updateListProductWhenRemove.call();
                      //   },
                      //   color: Colors.red,
                      //   icon: FaIcon(FontAwesomeIcons.minus),
                      // ),
                      // SizedBox(
                      //   height: 30,
                      //   width: 30,
                      //   child: TextFormField(
                      //     controller: productAmount,
                      //     keyboardType: TextInputType.number,
                      //     //  / initialValue: widget.product.amount.toString(),
                      //     textAlign: TextAlign.center,
                      //     onEditingComplete: () => {
                      //       setState(() {
                      //         widget.product.amount =
                      //             int.parse(productAmount.text);
                      //       })
                      //     },
                      //   ),
                      // ),
                      // IconButton(
                      //   color: Colors.green,
                      //   icon: FaIcon(FontAwesomeIcons.plus),
                      //   onPressed: () {
                      //     setState(() {
                      //       widget.product.amount++;
                      //       productAmount.text =
                      //           widget.product.amount.toString();
                      //       print(widget.product.amount.toString());
                      //       widget.updateTotalMoney.call();
                      //       widget.updateProductAmount.call();
                      //     });
                      //   },
                      // ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
