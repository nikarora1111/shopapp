import 'package:flutter/material.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/order_item.dart' as ord;

class OrderScreen extends StatelessWidget {
  static const routeName = '/order-screen';

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An Error Occured'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemBuilder: (ctx, i) => ord.OrderItem(orderData.orders[i]),
                  itemCount: orderData.orders.length,
                ),
              );
            }
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
