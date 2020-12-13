import 'package:SPK_Coffee/Models/Product.dart';
import 'package:SPK_Coffee/Utils/StaticValue.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ProductComponent extends StatefulWidget {
  final Products products;
  final Function incrementCounter;
  final Function decrementCounter;
  final Function addProductToCart;
  final isUpdateInCart;
  ProductComponent(
      {this.products,
      this.incrementCounter,
      this.decrementCounter,
      this.addProductToCart,
      this.isUpdateInCart,
      key})
      : super(key: key);

  @override
  _ProductComponentState createState() => _ProductComponentState();
}

class _ProductComponentState extends State<ProductComponent> {
  int productCounter = 0;
  Products product = new Products();

  final formatter = new NumberFormat("#.###");
  @override
  Widget build(BuildContext context) {
    if (widget.isUpdateInCart == true) {
      if (widget.products.amount == null)
        productCounter = 0;
      else
        productCounter = widget.products.amount;
    }

    return Builder(
      builder: (context) {
        return Card(
          color: Colors.white70,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              GridTile(
                header: Center(
                  child: Text(
                    widget.products.productName,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.024),
                  ),
                ),
                footer: Container(
                  child: Stack(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      productCounter != 0
                          ? SizedBox(
                              height: 50,
                              width: 50,
                              child: Card(
                                shadowColor: Colors.blue,
                                color: Colors.white,
                                child: IconButton(
                                    iconSize: 20,
                                    padding: EdgeInsets.all(0.0),
                                    color: Colors.red,
                                    icon: FaIcon(FontAwesomeIcons.minus),
                                    onPressed: () {
                                      print('OK');
                                      widget.decrementCounter();
                                      setState(
                                        () {
                                          productCounter--;
                                          widget.products.amount =
                                              productCounter;
                                          widget.addProductToCart(
                                              widget.products);
                                        }, //Decrement product
                                      );
                                    }),
                              ),
                            )
                          : Container(),
                      // Padding(
                      //   padding: EdgeInsets.all(10),
                      //   child: Text(
                      //     formatter
                      //         .format(int.parse(widget.products.price)),
                      //     style: TextStyle(
                      //         fontSize:
                      //             MediaQuery.of(context).size.height *
                      //                 0.026),
                      //   ),
                      // ),
                      // SizedBox(
                      //     width: MediaQuery.of(context).size.width / 15)
                      Padding(
                        child: Center(
                          child: Text(
                            formatter.format(int.parse(widget.products.price)),
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.026),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      )
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: InkWell(
                    child: Card(
                      shadowColor: Colors.black,
                      child: Image.network(
                          StaticValue.path + '${widget.products.mainImage}',
                          fit: BoxFit.fill),
                    ),
                    onTap: () {
                      widget.incrementCounter(); //tăng số trong floating
                      setState(() {
                        //   print(productCounter);
                        productCounter++;
                        widget.products.amount = productCounter;
                        widget.addProductToCart(widget.products);
                      });
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 30, 30, 0),
                child: Text(
                  productCounter != 0 ? 'x${productCounter.toString()}' : '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.027,
                    color: Colors.purpleAccent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
