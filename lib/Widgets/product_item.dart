import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Providers/product.dart';
import 'package:shop_app/Screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Providers/products.dart';
import 'package:shop_app/Providers/cart.dart';
import 'package:shop_app/Providers/auth.dart';

class ProductItem extends StatelessWidget {
  //final Product product;

  //const ProductItem({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
   final authData = Provider.of<Auth>(context,listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return ProductDetailScreen(product);
          }));
        },
        child: GridTile(
          child: Hero(
              tag: product.id,
              child: Image.network(product.imageUrl)),
          footer: GridTileBar(
            title: Text(
              product.title,
              style: TextStyle(color: Colors.white, fontSize: 11),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black45,
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Colors.white,
                iconSize: 20,
                onPressed: () {
                  product.toggleFavoriteStatus(
                      authData.token!,
                          authData.userId!
                     // FirebaseAuth.instance.currentUser!.getIdToken().toString(),
                      //FirebaseAuth.instance.currentUser!.uid
                  );
                },
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Colors.white,
              iconSize: 20,
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Added item to Cart!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(label: 'UNDO', onPressed: () {
                    cart.removeSingleItem(product.id);
                  }),
                ));
              },
            ),
          ),
        ),
      ),
    );
    //);
  }
}
