import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/card_item.dart' as ci;
import '../providers/orders.dart';
class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => ci.CartItem(
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].title,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].price),
              itemCount: cart.items.length,
            ),
          )
        ],
      ),
    );
  }
}
class OrderButton extends StatefulWidget {
  final Cart cart;
  OrderButton(this.cart);
  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isloading=false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isloading? CircularProgressIndicator():Text('Order Now'),
      onPressed:(widget.cart.totalAmount<=0 || _isloading)?null: () async {
        setState(() {
          _isloading=true;
        });
        await Provider.of<Orders>(context,listen: false).adddOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
        setState(() {
          _isloading=false;
        });
        widget.cart.clear();
      },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
