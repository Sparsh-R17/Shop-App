import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              print(value);
              setState(() {
                if (value == FilterOptions.favorites) {
                  _showOnlyFavorites = true;
                  // productsContainer.showFavoritesOnly();
                } else {
                  _showOnlyFavorites = false;
                  // productsContainer.showAll();
                }
              });
            },
            icon: const Icon(Icons.more_vert_rounded),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Only Favorite'),
              ),
              PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show All'),
              )
            ],
          ),
        ],
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: ProductsGrid(showFavs: _showOnlyFavorites),
      ),
    );
  }
}
