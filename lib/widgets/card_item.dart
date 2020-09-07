import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';

class CartItem extends StatefulWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String productId;

  CartItem(this.id, this.productId, this.title, this.quantity, this.price);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          Provider.of<Cart>(context, listen: false)
              .removeItem(widget.productId);
        },
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('Are you sure'),
                    content: Text('Do you want to remove item?'),
                    actions: <Widget>[
                      FlatButton(onPressed: () {Navigator.of(ctx).pop(false);}, child: Text('NO')),
                      FlatButton(onPressed: () {Navigator.of(ctx).pop(true);}, child: Text('YES'))
                    ],
                  ));
          //return Future.value(true);
        },
        key: ValueKey(widget.id),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(10),
        ),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: FittedBox(child: Text('\$${widget.price}')),
              ),
              title: Text(widget.title),
              subtitle: Text('Total: \$${widget.price * widget.quantity}'),
              trailing: Text('${widget.quantity}'),
            ),
          ),
        ));
  }
}
