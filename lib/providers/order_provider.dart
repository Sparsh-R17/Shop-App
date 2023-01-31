import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/order_item.dart';

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amt: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
