import 'package:flutter/material.dart';
import 'package:shop_app/widgets/product_item.dart';

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

  List<Product> get favoriteItems{
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

  void addProduct() {
    // _items.add(value);
    //& Notify listeners tell the widgets using this class that there is a change in the list _items
    notifyListeners();
  }
}
