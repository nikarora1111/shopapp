import 'package:flutter/material.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import '../models/product.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import 'cart_screen.dart';
import 'dart:convert';
enum FilterOptions{
  Favorites,
  All,
}
class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites=false;
var _isinit=true;
var _isloading = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(_isinit){
      setState(() {
        _isloading=true;
      });
      Provider.of<Products>(context).fetchAndSetProduct().then((_){
        setState(() {
          _isloading=false;
        });
      });
      if(Provider.of<Products>(context).items.length!=0)
        _isinit=false;
//      _isinit=false;
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            onSelected:(FilterOptions selectedValue){
              setState(() {
                if(selectedValue==FilterOptions.Favorites){
                  //..
                  _showOnlyFavorites=true;
                }
                else{
                  _showOnlyFavorites=false;
                }
              });
            },
            icon: Icon(Icons.more_vert),itemBuilder: (_)=>[
            PopupMenuItem(child: Text('Only Favourite'),value:FilterOptions.Favorites ,),
            PopupMenuItem(child: Text('Show All'),value:FilterOptions.All ,),
          ],),
          Consumer<Cart>(builder: (_,cart,ch)=>Badge(
              child: ch,
              value: cart.itemCount.toString()),
          child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){
            Navigator.of(context).pushNamed(CartScreen.routeName);
          }),),
        ],
        title: Text('MyShop'),
      ),
      drawer: AppDrawer(),
      body:_isloading?Center(child: CircularProgressIndicator(),):ProductsGrid(_showOnlyFavorites),
    );
  }
}

