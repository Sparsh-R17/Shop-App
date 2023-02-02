import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartItemTile extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  const CartItemTile({
    super.key,
    required this.id,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Are you sure ?'),
                  content: const Text(
                      'Do you want to remove the item from the cart ?'),
                  actions: [
                    TextButton(
                      child: const Text('NO'),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    TextButton(
                      child: const Text('YES'),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ));
      },
      background: Container(
        color: Theme.of(context).colorScheme.secondary,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('$quantity X'),
          ),
        ),
      ),
    );
  }
}
