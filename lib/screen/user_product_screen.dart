import 'package:flutter/material.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/user_product_item.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../screen/edit_prooduct_screen.dart';
class UserProductsScreen extends StatelessWidget {
  static const routeName = '/product-screen';
  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<Products>(context).fetchAndSetProduct();
  }
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductSScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: (){
          return _refreshProducts(context);
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (_, i) => Column(
              children: <Widget>[

                UserProductItem(
                    productsData.items[i].id,productsData.items[i].title, productsData.items[i].imageUrl),
                Divider(),
              ],
            ),
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
