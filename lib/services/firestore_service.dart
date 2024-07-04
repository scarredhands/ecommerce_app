import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // Fetch all cart items for a user (assuming userId is available)
  Future<List<CartItem>> getCartItems(String userId) async {
    print('Fetching cart items for user: $userId');

    try {
      final cartRef = _db.collection('users').doc(userId).collection('cart');
      print('Cart reference path: ${cartRef.path}');

      QuerySnapshot querySnapshot;
      try {
        querySnapshot = await cartRef.get();
        print(
            'Query snapshot obtained. Document count: ${querySnapshot.docs.length}');
      } catch (e) {
        print('Error fetching query snapshot: $e');
        return [];
      }

      if (querySnapshot.docs.isEmpty) {
        print('No cart items found for user: $userId');
        return [];
      }

      List<CartItem> cartItems = [];
      for (var doc in querySnapshot.docs) {
        print('Processing document: ${doc.id}');
        try {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          CartItem item = CartItem.fromFirestore(data, doc.id);
          cartItems.add(item);
        } catch (e) {
          print('Error processing cart item ${doc.id}: $e');
          // Continue to next document instead of throwing
        }
      }

      print(
          'Successfully fetched ${cartItems.length} cart items for user: $userId');
      return cartItems;
    } catch (e) {
      print('Unexpected error in getCartItems: $e');
      return []; // Return empty list instead of throwing
    }
  }

  // Add a cart item
  Future<void> addCartItem(String userId, CartItem cartItem) async {
    try {
      var cartCollection =
          _db.collection('users').doc(userId).collection('cart');
      await cartCollection.doc(cartItem.id).set(cartItem.toFirestore());
    } catch (e) {
      throw Exception("Failed to add cart item: $e");
    }
  }

  // Remove a cart item
  Future<void> removeCartItem(String userId, String cartItemId) async {
    try {
      var cartCollection =
          _db.collection('users').doc(userId).collection('cart');
      await cartCollection.doc(cartItemId).delete();
    } catch (e) {
      throw Exception("Failed to remove cart item: $e");
    }
  }

  // Fetch a list of products
  Future<List<Product>> fetchProducts() async {
    try {
      QuerySnapshot snapshot = await _db.collection('products').get();
      return snapshot.docs
          .map((doc) =>
              Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  Future<void> addToCart(Product product, int quantity) async {
    try {
      // Get current user ID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      String userId = user.uid;

      // Reference to the user's cart collection
      final cartRef = _db.collection('users').doc(userId).collection('cart');

      // Check if the product already exists in the cart
      QuerySnapshot existingItems = await cartRef
          .where('productId', isEqualTo: product.id)
          .limit(1)
          .get();

      if (existingItems.docs.isNotEmpty) {
        // If the product exists, update the quantity
        DocumentReference docRef = existingItems.docs.first.reference;
        await docRef.update({'quantity': FieldValue.increment(quantity)});
      } else {
        // If the product doesn't exist, add a new document
        await cartRef.add({
          'productId': product.id,
          'productName': product.title,
          'quantity': quantity,
          // Add other relevant fields as needed
        });
      }

      print('Product added to cart successfully');
    } catch (e) {
      print('Failed to add product to cart: $e');
      throw Exception('Failed to add product to cart: $e');
    }
  }
}
