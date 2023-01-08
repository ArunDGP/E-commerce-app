import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Screens/products_overview_screen.dart';
import 'package:shop_app/Screens/product_detail_screen.dart';
import 'package:shop_app/Providers/products.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Providers/product.dart';
import 'package:shop_app/Providers/cart.dart';
import 'package:shop_app/Widgets/cart_screen.dart';
import 'package:shop_app/Widgets/order_screen.dart';
import '../Providers/orders.dart';
import 'package:shop_app/Screens/user_products_screen.dart';
import 'package:shop_app/Screens/edit_product_screen.dart';
import 'package:shop_app/Screens/auth_screen.dart';
import 'package:shop_app/Providers/auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    //ChangeNotifierProvider(create: (_) => Products()),
    ChangeNotifierProvider(create: (_) => Auth()),
    ChangeNotifierProxyProvider<Auth, Products>(
      create: (context) => Products(
          Provider.of<Auth>(context, listen: false).token.toString(),
          Provider.of<Auth>(context, listen: false).userId.toString()),
      update: (_, auth,
              previousProducts) => //No need of this- 'previousProducts'. But i used, bcause i saw that in someSolution for my error
          Products(auth.token.toString(), auth.userId.toString()),
    ),

    ChangeNotifierProvider(create: (_) => Cart()),
    // ChangeNotifierProvider(create: (_) => Orders()),
    ChangeNotifierProxyProvider<Auth, Orders>(
        create: (context) =>
            Orders(Provider.of<Auth>(context, listen: false).token.toString()),
        update: (_, auth, anythingYouwant) => Orders(auth.token.toString()))
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final auth = Provider.of<Auth>(context);
    return Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
              title: 'MyShopApp',
              theme: ThemeData(
                primarySwatch: Colors.green,
              ),
              home: //FirebaseAuth.instance.currentUser?.getIdToken() != null
                  auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
              //ProductOverviewScreen(),
              routes: {
                CartScreen.routeName: (ctx) => CartScreen(),
                OrderScreen.routeName: (ctx) => OrderScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
              },
            ));
  }
}
