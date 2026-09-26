import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projflutter/data/app_data.dart';
import 'package:projflutter/pages/product_detail_page.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  void initState() {
    super.initState();
    appData.addListener(_update);
  }

  @override
  void dispose() {
    appData.removeListener(_update);
    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: appData.products.length,
      itemBuilder: (context, index) {
        final product = appData.products[index];
        return Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: product.imagePath != null
                      ? Image.file(File(product.imagePath!), width: 70, height: 70, fit: BoxFit.cover)
                      : Container(
                          width: 70,
                          height: 70,
                          color: Colors.brown[100],
                          child: const Icon(Icons.shopping_basket, color: Colors.white, size: 32),
                        ),
                ),
                title: Text(product.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text('\$${product.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                  ],
                ),
                isThreeLine: true,
              ),
            ),
          ),
        );
      },
    );
  }
}
