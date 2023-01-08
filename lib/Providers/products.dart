import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth.dart';
import 'package:provider/provider.dart';


class Products with ChangeNotifier {
  final String authToken;
  final String localId;
  Products(this.authToken,this.localId);
  //final idToken = FirebaseAuth.instance.currentUser?.getIdToken();
  //final localId = FirebaseAuth.instance.currentUser?.uid;

  List<Product> _items = [
    //Product('P1', ' T-Shirt', 'Its Good', 50.0,
    //  'https://shop.inkholic.in/wp-content/uploads/2018/12/Red-780x733.jpg'),
    //Product('P2', ' Pant', 'Its Comfortable', 60,
    //  'https://s3-eu-west-1.amazonaws.com/images.linnlive.com/fa277a4a27060ab10fac46d8ded1244b/c4e24d21-4f7f-4dbf-a84a-ff021b540db7.jpg'),
    //Product('P3', 'TV', 'Its Smart', 250,
    //   'https://i.gadgets360cdn.com/products/televisions/large/1548153593_832_lg_55-inch-led-full-hd-tv-55lh600t.jpg'),
    // Product('P4', 'Pan', 'Its heavy', 25,
    // 'https://images-na.ssl-images-amazon.com/images/I/31weSNr0i-L.jpg')
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://myshopapp-b4ec9-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken'; //?auth=${FirebaseAuth.instance.currentUser!.getIdToken().toString()}';
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId' : localId
            //'isFavorite': product.isFavorite,
          }));
      final newProduct = Product(jsonDecode(response.body)['name'],
          product.title, product.description, product.price, product.imageUrl);
      _items.add(newProduct);
      // _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> fetchAndSetProducts([bool filterByUser =false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalto="$localId"' : '';
    var url =
        'https://myshopapp-b4ec9-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filterString ';
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as  Map<String,dynamic>; //extractedData is a Map
    if(extractedData==null){
      return ;
    }
    url = 'https://myshopapp-b4ec9-default-rtdb.asia-southeast1.firebasedatabase.app//userFavorites/$localId.json?auth=$authToken';
     final favoriteResponse = await http.get(Uri.parse(url));
     final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        //print("Product Data:");
       // print(prodData);
        //print(extractedData);
        loadedProducts.add(Product(
          prodId,
          prodData['title'],
          prodData['description'],
          double.parse(prodData['price'].toString()),
          prodData['imageUrl'],
          isFavorite: favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    }


  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://myshopapp-b4ec9-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken'; //?auth=${FirebaseAuth.instance.currentUser!.getIdToken().toString()}';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProducts(String id) async {
    final url =
        'https://myshopapp-b4ec9-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken'; //?auth=${FirebaseAuth.instance.currentUser!.getIdToken().toString()}';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
        if(response.statusCode >= 400) {
          _items.insert(existingProductIndex, existingProduct);
          notifyListeners();
        }
      existingProduct = null!;



  }
}
