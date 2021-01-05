import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/Models/OrderDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrderItem extends StatefulWidget {
  final Order details;
  final OrderTable orderTable;
  final List<ProductsInfo> productInfo;
  final Function(List<OrderDetail>, List<ProductsInfo>) popDetails;
  final Function(Order) getRemoveItem;
  const OrderItem(
      {this.details,
      this.orderTable,
      this.productInfo,
      this.popDetails,
      this.getRemoveItem});
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isHaveTable = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isHaveTable = widget.orderTable != null ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        widget.popDetails(widget.details.details, widget.productInfo);
      },
      onTap: () {
        widget.getRemoveItem(widget.details);
      },
      child: Container(
        key: Key('${widget.details.id}'),
        decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border.all(
              width: 0.5,
              color: Colors.black38,
            )),
        child: Column(
          children: [
            Text(
              "Order no: ${widget.details.id}",
            ),
            _isHaveTable
                ? Text("Table: ${widget.orderTable.tablename}")
                : Text(""),
          ],
        ),
      ),
    );
  }
}
