import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

class ProductsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Product>> fetchShoes() async {
    try {
      QuerySnapshot snapshot = await _db.collection('shoes').get();
      return snapshot.docs
          .map((doc) =>
              Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  Future<List<Product>> fetchProductsByCategory(String category) async {
    try {
      // Get the products collection from Firestore
      CollectionReference products = _db.collection('products');

      // Query to get products where the category field matches the given category
      QuerySnapshot querySnapshot =
          await products.where('category', isEqualTo: category).get();

      // Map each document in the query result to a Product object
      return querySnapshot.docs.map((doc) {
        return Product.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching products by category: $e");
      return [];
    }
  }
}
