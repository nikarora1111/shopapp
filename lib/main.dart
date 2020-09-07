import 'package:flutter/material.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/screen/product_screen.dart';
import 'package:shopapp/screen/products_overview_screen.dart';
import 'package:shopapp/screen/user_product_screen.dart';
import 'providers/products.dart';
import 'package:provider/provider.dart';
import 'screen/cart_screen.dart';
import 'providers/orders.dart';
import 'screen/order_screen.dart';
import 'screen/edit_prooduct_screen.dart';
import 'screen/auth_screen.dart.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
        value: Products(),
      ),
        ChangeNotifierProvider.value(
            value: Cart(),
        ),
      ChangeNotifierProvider.value(
          value: Orders()
      ),
      ChangeNotifierProvider.value(
          value: Auth()
      )
      ],
      child:  Consumer<Auth>(builder: (ctx,auth,child)=>MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: auth.isAuth?ProductOverviewScreen():AuthScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx)=>ProductDetailScreen(),
          CartScreen.routeName:(ctx)=>CartScreen(),
          OrderScreen.routeName:(ctx)=>OrderScreen(),
          UserProductsScreen.routeName:(ctx)=>UserProductsScreen(),
          EditProductSScreen.routeName:(ctx)=>EditProductSScreen(),
        },
      )),
    );
  }
}