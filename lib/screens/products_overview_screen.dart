import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/products_grid.dart';

import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';

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
  var _isLoading = false;
  // var _isInit = true;

  @override
  void initState() {
    // without listen = false u cant use provider in initState
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductProvider>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });

    //& if listen = true and want to call provider use future.delay
    //& its acts as a todo this line is executed once we the widget is initialized
    // Future.delayed(Duration.zero)
    //     .then((_) => Provider.of<ProductProvider>(context));
    super.initState();
  }

  //^ we can use this method if we want listen = true;
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     Provider.of<ProductProvider>(context).fetAndSetProducts();
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<ProductProvider>(context);
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
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
          Consumer<Cart>(
            builder: (context, value, child) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0, top: 1),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                    child: Badge(
                      label: Text(value.itemCount.toString()),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      isLabelVisible: true,
                      child: const Icon(Icons.shopping_cart),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowIndicator();
            return true;
          },
          child: _isLoading
              ? loadingIndicator(context)
              : ProductsGrid(showFavs: _showOnlyFavorites)),
    );
  }

  Widget loadingIndicator(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Please Wait ...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
