import 'package:flutter/material.dart';
import 'package:shop_app/Providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  const CartItem(
      this.id, this.productId, this.title, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 21),
        color: Theme.of(context).disabledColor,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context,listen: false).removeItem(productId);
      },

      confirmDismiss: (direction) {
       return showDialog(context: context, builder:(ctx) => AlertDialog(
         title: Text('Are you sure?'),
         content: Text('Do you want to remove the item from the cart?'),
         actions: [
           TextButton(onPressed: (){
             Navigator.of(context).pop(true);
           }, child: Text('Yes')),
           TextButton(onPressed: (){
             Navigator.of(context).pop(false);
           }, child: Text('No'))
         ],
       ) ); },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
              leading: CircleAvatar(
              child: Padding(
              padding: EdgeInsets.all(5),
          child: FittedBox(child: Text('\$${price}')),
        ),
        ),
        title: Text(title),
        subtitle: Text('Total = \$${quantity * price}'),
                    trailing: Text('$quantity x'),
            )),
      ),
    );
  }
}
