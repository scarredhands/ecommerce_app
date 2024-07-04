import 'package:flutter/material.dart';

import '../models/product.dart';

class LikedItemsScreen extends StatelessWidget {
  final List<Product> likedItems;

  const LikedItemsScreen({super.key, required this.likedItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Items'),
        centerTitle: true,
      ),
      body: likedItems.isEmpty
          ? Center(child: const Text('No liked items yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: likedItems.length,
              itemBuilder: (context, index) {
                final item = likedItems[index];
                return ListTile(
                  leading: Image.asset(item.image),
                  title: Text(item.title),
                  subtitle: Text("\$${item.price}"),
                );
              },
            ),
    );
  }
}
