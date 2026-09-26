import 'package:flutter/material.dart';
import 'package:projflutter/data/app_data.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = appData.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: orders.isEmpty
          ? const Center(child: Text('You have no orders yet.'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text('Order #${order.id.substring(0, 8)}...'),
                    subtitle: Text('${DateFormat.yMMMd().format(order.date)} - \$${order.totalPrice.toStringAsFixed(2)}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Deliver to:', style: Theme.of(context).textTheme.titleMedium),
                            Text(order.fullName),
                            Text(order.address),
                            Text('${order.city}, ${order.postalCode}'),
                            const SizedBox(height: 16),
                            Text('Items:', style: Theme.of(context).textTheme.titleMedium),
                            ...order.items.map((item) => ListTile(
                                  title: Text(item.product.name),
                                  trailing: Text('${item.quantity} x \$${item.product.price.toStringAsFixed(2)}'),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
