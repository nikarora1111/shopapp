import 'package:flutter/material.dart';
import 'package:shopapp/screen/product_screen.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

class ProductItem extends StatelessWidget {
  //ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);
    final cart = Provider.of<Cart>(context,listen: false);
    //print('rebuild');
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
                builder: (ctx, product, child) => IconButton(
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () {
                      product.toggleFavoriteStatus();
                    })),
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart,
                    color: Theme.of(context).accentColor),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  //product.toggleFavoriteStatus();
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Your item added to cart',
                      textAlign: TextAlign.center,
                    ),
                    action: SnackBarAction(label: 'UNDO',onPressed: (){
                      cart.removeSingleItem(product.id);
                    },),
                    duration: Duration(seconds: 2),
                  ));
                }),
          ),
        ),
      ),
    );
  }
}
