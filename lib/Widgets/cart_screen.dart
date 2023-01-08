import 'package:flutter/material.dart';
import 'package:shop_app/Providers/cart.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Widgets/cart_item.dart' as ci;
import '../Providers/orders.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '\\Cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.deepOrange,
                  ),
                  Spacer(),
                  TextButton(
                    child: _isLoading ? CircularProgressIndicator() : Text(
                      'ORDER NOW',
                      style: TextStyle(color: Colors.blue),
                    ),
                      onPressed: (cart.totalAmount <=0 || _isLoading )? null : () async {
                      setState(() {
                        _isLoading = true;
                      });
                        await Provider.of<Orders>(context, listen: false).addOrder(
                            cart.totalAmount, cart.items.values.toList());
                        setState(() {
                          _isLoading = false;
                        });
                        cart.clear();
                      },)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) => ci.CartItem(
                    cart.items.values.toList()[i].id,
                    cart.items.keys.toList()[i],
                    cart.items.values.toList()[i].title,
                    cart.items.values.toList()[i].price,
                    cart.items.values.toList()[i].quantity)),
          )
        ],
      ),
    );
  }
}
