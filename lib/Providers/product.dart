import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  //final String authToken;
  bool isFavorite;


  Product(
       this.id,
      this.title,
      this.description,
      this.price,
      this.imageUrl,
      //this.authToken,
       {    this.isFavorite = false,  }
      );
  //void favoriteButtonClicked() {
    //isFavorite = !isFavorite;
    //notifyListeners();
  //}
 Future<void> toggleFavoriteStatus(String token, String userId ) async {   //

    final oldStatus = isFavorite ;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://myshopapp-b4ec9-default-rtdb.asia-southeast1.firebasedatabase.app//userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(Uri.parse(url),
      body: json.encode(
         isFavorite
      ));
    } catch(error){
     throw error; }
 }
}