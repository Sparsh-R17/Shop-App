import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail-screen';
  const ProductDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProuct = Provider.of<ProductProvider>(context, listen: false)
        .findbyId(productId);

    return Scaffold(
      appBar: AppBar(title: Text(loadedProuct.title)),
    );
  }
}
