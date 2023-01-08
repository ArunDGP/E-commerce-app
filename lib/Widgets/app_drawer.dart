import 'package:flutter/material.dart';
import 'order_screen.dart';
import 'package:shop_app/Screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Providers/auth.dart';
class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(child: Column(children: [
      AppBar(title: Text('Hello Friend'),
      automaticallyImplyLeading: false,),
      Divider(),
      ListTile(leading: Icon(Icons.shop),title: Text('Shop'),
      onTap: (){ Navigator.of(context).pushReplacementNamed('/');
      }),
      Divider(),
      ListTile(leading: Icon(Icons.payment), title: Text('Orders'),
      onTap: (){Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);},),
      Divider(),
    ListTile(leading: Icon(Icons.edit),title: Text('Manage Products'),
    onTap: () { Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);},),
      Divider(),
      ListTile(leading: Icon(Icons.logout),title: Text('Logout'),
      onTap: () {
        Provider.of<Auth>(context,listen: false).logout();
        Navigator.of(context).pop();
      },),
      Divider(),

    ],),);
  }
}
