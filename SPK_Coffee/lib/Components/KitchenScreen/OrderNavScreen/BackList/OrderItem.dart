import 'package:SPK_Coffee/Models/Order.dart';
import 'package:SPK_Coffee/Models/OrderDetail.dart';
import 'package:SPK_Coffee/Utils/FormatString.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OrderItem extends StatefulWidget {
  final Order details;
  final OrderTable orderTable;
  final List<ProductsInfo> productInfo;
  final Function(List<OrderDetail>, List<ProductsInfo>) popDetails;
  final Function(Order) getRemoveItem;
  final Function(String, String) updateOrderByState;
  const OrderItem(
      {this.details,
      this.orderTable,
      this.productInfo,
      this.popDetails,
      this.getRemoveItem,
      this.updateOrderByState});
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
      // onLongPress: () {
      //   widget.popDetails(widget.details.details, widget.productInfo);
      // },
      onTap: () {
        // widget.getRemoveItem(widget.details);
        widget.popDetails(widget.details.details, widget.productInfo);
      },
      child: Slidable(
        key: Key('${widget.details.id}'),
        actionPane: SlidableDrawerActionPane(),
        child: Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(5),
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.12
              : MediaQuery.of(context).size.height * 0.18,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
                // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: Colors.green,
                  size: 54,
                ),
                flex: 2,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order no: ${widget.details.id}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    _isHaveTable
                        ? Text(
                            "Table: ${widget.orderTable.tablename}",
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          )
                        : Text("Online Order",
                            style: TextStyle(color: Colors.grey, fontSize: 15)),
                    Text(formatDateToString(widget.details.date))
                  ],
                ),
                flex: 6,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        widget.details.state != "processing"
                            ? widget.details.state
                            : "process",
                        style: TextStyle(
                            color: widget.details.state == "open"
                                ? Color.fromRGBO(165, 241, 40, 1)
                                : (widget.details.state == "processing"
                                    ? Colors.yellow
                                    : Colors.blue),
                            fontSize: 17),
                      ),
                    )
                  ],
                ),
                flex: 2,
              )
            ],
          ),
        ),
        secondaryActions: [
          Container(
            margin: EdgeInsets.only(top: 5, left: 2),
            height: MediaQuery.of(context).size.height * 0.12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                  // changes position of shadow
                ),
              ],
            ),
            child: IconSlideAction(
              icon: Icons.access_alarm,
              caption: "Process",
              color: Colors.yellow,
              onTap: () =>
                  {widget.updateOrderByState(widget.details.id, "processing")},
            ),
          )
        ],
        actions: [
          Container(
            margin: EdgeInsets.only(top: 5, right: 2),
            height: MediaQuery.of(context).size.height * 0.12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                  // changes position of shadow
                ),
              ],
            ),
            child: IconSlideAction(
              icon: Icons.check,
              caption: "Ready",
              color: Color.fromRGBO(165, 241, 40, 0.5),
              onTap: () =>
                  {widget.updateOrderByState(widget.details.id, "ready")},
            ),
          )
        ],
      ),
    );
  }
}

/*

Container(
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
      )


*/
