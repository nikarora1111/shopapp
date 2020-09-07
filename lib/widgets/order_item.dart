import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(@required this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
@override
  void initState() {
    // TODO: implement initState
  _expanded=false;
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle:
            Text(DateFormat('dd MM yyyy hh::mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: _expanded ? Icon(Icons.expand_less) : Icon(
                  Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if(_expanded)
            Container(height: min(
                widget.order.products.length * 20.0 + 100, 180),
              child: ListView(children: widget.order.products.map((product) =>
                  Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: <Widget>[
                    Text(product.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight
                          .bold),),
                    Text(
                      '${product.quantity}x \$${product.price}',style: TextStyle(fontSize: 14),
                    )
                  ],)).toList(),),)
        ],
      ),
    );
  }
}
