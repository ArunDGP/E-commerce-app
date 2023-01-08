import 'package:flutter/material.dart';
import 'package:shop_app/Providers/products.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Widgets/user_product_item.dart';
import 'package:shop_app/Widgets/app_drawer.dart';
import 'package:shop_app/Screens/edit_product_screen.dart';
import 'package:shop_app/Providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user_products';
  //const UserProductsScreen({Key? key}) : super(key: key);
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: FutureBuilder(
            future: _refreshProducts(context),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: () => _refreshProducts(context),
                        child: Consumer<Products>(
                          builder: (ctx, productsData, _) => Padding(
                            padding: EdgeInsets.all(8),
                            child: ListView.builder(
                                itemCount: productsData.items.length,
                                itemBuilder: (_, i) => UserProductItem(
                                    productsData.items[i].id,
                                    productsData.items[i].title,
                                    productsData.items[i].imageUrl)),
                          ),
                        ),
                      )));
  }
}
