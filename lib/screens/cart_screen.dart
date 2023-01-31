import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart' show Cart;
import '../providers/order_provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Consumer<Cart>(
                    builder: (context, carts, child) {
                      return Chip(
                        label: Text(
                          '\$${carts.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Order>(context, listen: false).addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,
                      );
                      cart.clearItems();
                    },
                    child: const Text('ORDER NOW'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                return CartItemTile(
                  productId: cart.items.keys.toList()[index],
                  id: cart.items.values.toList()[index].id,
                  price: cart.items.values.toList()[index].price,
                  quantity: cart.items.values.toList()[index].quantity,
                  title: cart.items.values.toList()[index].title,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
