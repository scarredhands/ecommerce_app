import 'package:flutter/material.dart';

class Product {
  final String id; // Firestore document ID
  final String title;
  final String description;
  final String image;
  final double price;
  final List<Color> colors;
  final String category;
  final double rate;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.colors,
    required this.category,
    required this.rate,
  });

  // Factory method to create a Product from a Firestore document
  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      colors: (data['colors'] as List<dynamic>)
          .map((colorName) => colorNameToColor(colorName.toString()))
          .toList(),
      category: data['category'] ?? '',
      rate: (data['rate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Helper function to convert color name to Color object
  static Color colorNameToColor(String colorName) {
    switch (colorName) {
      case 'Colors.black':
        return Colors.black;
      case 'Colors.blue':
        return Colors.blue;
      case 'Colors.red':
        return Colors.red;
      case 'Colors.green':
        return Colors.green;
      case 'Colors.orange':
        return Colors.orange;
      case 'Colors.pink':
        return Colors.pink;
      case 'Colors.purple':
        return Colors.purple;
      case 'Colors.yellow':
        return Colors.yellow;
      case 'Colors.brown':
        return Colors.brown;
      case 'Colors.grey':
        return Colors.grey;
      case 'Colors.cyan':
        return Colors.cyan;
      case 'Colors.indigo':
        return Colors.indigo;
      // Add more colors as needed
      default:
        return Colors.transparent; // Default or unknown color
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'colors': colors,
      'category': category,
      'rate': rate
    };
  }
}
