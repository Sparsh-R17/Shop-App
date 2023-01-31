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
    final loadedProduct = Provider.of<ProductProvider>(context, listen: false)
        .findbyId(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              '\$${loadedProduct.price}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
