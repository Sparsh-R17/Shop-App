import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // var _showFavorites = false;

  List<Product> get items {
    // if (_showFavorites) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    //&this lines gives a copy of _items to items using getter function
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findbyId(String id) {
    return _items.firstWhere(
      (prodItem) => prodItem.id == id,
    );
  }

  // void showFavoritesOnly() {
  //   _showFavorites = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavorites = false;
  //   notifyListeners();
  // }

  Future<void> addProduct(Product product) {
    final url = Uri.parse(
        'https://shop-app-d57ee-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');

    // 2nd method
    // Uri.https('shop-app-d57ee-default-rtdb.asia-southeast1.firebasedatabase.app','/products.json');

    return http
        .post(
      url,
      body: json.encode(
        {
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'isFavorite': product.isFavorite,
          'imageUrl': product.imageUrl,
        },
      ),
    )
        .then((value) {
      final newProduct = Product(
        id: json.decode(value.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      //& Notify listeners tell the widgets using this class that there is a change in the list _items
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  void updateProduct(String id, Product product) {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    _items[prodIndex] = product;
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
