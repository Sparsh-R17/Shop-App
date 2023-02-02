import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/colors.dart';
import '/screens/product_detail_screen.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  const ProductItem({
    super.key,
    // required this.id,
    // required this.title,
    // required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    // print('Checking whether provider is working or not');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          );
        },
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              //^ Child is the widget that never changes value after building also
              builder: (context, value, child) => IconButton(
                icon: value.isFavorite
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border),
                color: AppColor.peach,
                onPressed: () {
                  value.toggleFavorite();
                },
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                cart.addItem(
                  product.id,
                  product.price,
                  product.title,
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Item Added to your cart'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ));
              },
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
