import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/order_item.dart';

import '../providers/order_provider.dart' show Order;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (context, index) {
          return OrderItem(
            order: orderData.orders[index],
          );
        },
      ),
    );
  }
}
