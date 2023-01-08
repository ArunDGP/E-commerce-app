import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/Widgets/order_item.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(this.id, this.amount, this.products, this.dateTime);
}

class Orders with ChangeNotifier {
 // final idToken = FirebaseAuth.instance.currentUser?.getIdToken();
  List<OrderItem> _orders = [];
  final String authToken;

  /////
  Orders(this.authToken);  ////

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(double total, List<CartItem> cartProducts) async {
    final url =
        'https://myshopapp-b4ec9-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json?auth=$authToken';
    final timeStamp = DateTime.now();

    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(json.decode(response.body)['name'], total, cartProducts,
            timeStamp));
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://myshopapp-b4ec9-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedProducts = [];
    final extratedData =
        await json.decode(response.body) as Map<String, dynamic>;
    extratedData.forEach((orderId, orderData) {
      loadedProducts.add(OrderItem(
          orderId,
          orderData['amount'],
          (orderData['products']  as List<dynamic>)     /////////////////////////////////////////////////////
              .map((item) => CartItem(
              item['id'], item['title'], item['price'], item['quantity'])).toList(),
          DateTime.parse(orderData['dateTime'])));
    });
    _orders = loadedProducts;
    notifyListeners();
  }
}
