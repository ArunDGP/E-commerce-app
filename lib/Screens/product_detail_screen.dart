import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Providers//products.dart';
import 'package:shop_app/Providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product loadedProduct;

  ProductDetailScreen(this.loadedProduct);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Column(
        children: [
          Container(            //////////////////////////////
            height: 300,
            width: double.infinity,
            color: Colors.black,
            child: Hero(
              tag: loadedProduct.id,
              child: Image.network(
                loadedProduct.imageUrl,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                '\$${loadedProduct.price}',
                style: TextStyle(fontSize: 20, ),
              )),
          SizedBox(height: 10),
          Text('${loadedProduct.title}' ,style: TextStyle(fontSize: 18),),
          SizedBox(height: 10,),
          Text('${loadedProduct.description}',style: TextStyle(fontSize: 18), )     /////////////////////////////
        ],
      ),
    );
  }
}
