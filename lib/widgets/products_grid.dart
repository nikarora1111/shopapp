import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/products_item.dart';
class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context,listen: true);
    print('listened');
    print(productsData.items.length);
    final products = showFavs?productsData.favoriteItems:productsData.items;
    return GridView.builder(

        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) =>
            ChangeNotifierProvider.value(
              value:products[index],
              child: ProductItem(
                  ),
            ));
  }
}
