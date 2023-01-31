import 'cart_item.dart';

class OrderItem {
  final String id;
  final double amt;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amt,
    required this.products,
    required this.dateTime,
  });
}
