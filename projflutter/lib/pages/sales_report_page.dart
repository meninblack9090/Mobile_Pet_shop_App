import 'package:flutter/material.dart';

class SalesReportPage extends StatelessWidget {
  const SalesReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Monthly Sales Summary',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.brown[800]),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: Icon(Icons.attach_money, color: Colors.green[700]),
            title: const Text('Total Sales'),
            trailing: Text('₱5,450.75', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green[800])),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.shopping_cart, color: Colors.brown[400]),
            title: const Text('Total Items Sold'),
            trailing: const Text('342', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Top Performing Items',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.brown[800]),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.brown[100],
            child: Text('1', style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold)),
          ),
          title: const Text('Premium Dog Food'),
          trailing: const Text('150 units'),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.brown[100],
            child: Text('2', style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold)),
          ),
          title: const Text('Cat Toys Bundle'),
          trailing: const Text('75 units'),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.brown[100],
            child: Text('3', style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold)),
          ),
          title: const Text('Grooming Special'),
          trailing: const Text('50 units'),
        ),
      ],
    );
  }
}
