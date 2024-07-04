import 'package:ecommerce_app/models/product.dart';

class CartItem {
  String id; // Unique identifier for the cart item
  int quantity;
  String productId; // Reference to the product's ID

  Product? product; // The actual Product object, fetched separately

  CartItem({
    required this.id,
    required this.quantity,
    required this.productId,
    this.product,
  });

  // Factory method to create a CartItem from Firestore document data
  factory CartItem.fromFirestore(Map<String, dynamic> data, String cartItemId) {
    return CartItem(
      id: cartItemId,
      quantity: data['quantity'] ?? 1,
      productId: data['productId'] ?? '',
      // Note: The product object is not initialized here. It will be fetched separately.
    );
  }

  // Convert CartItem to a Map for Firestore storage
  Map<String, dynamic> toFirestore() {
    return {
      'quantity': quantity,
      'productId': productId,
    };
  }
}
