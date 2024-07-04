import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../constants.dart';
import '../../models/product.dart';
import '../../services/firestore_service.dart';

class AddToCart extends StatelessWidget {
  final Function() onAdd;
  final Function() onRemove;
  final Product product;
  const AddToCart({
    Key? key,
    required this.currentNumber,
    required this.onAdd,
    required this.onRemove,
    required this.product,
  }) : super(key: key);

  final int currentNumber;

  @override
  Widget build(BuildContext context) {
    final FirestoreService _firestoreService = FirestoreService();

    void addToCart() async {
      try {
        await _firestoreService.addToCart(product, currentNumber);
        print("Product added to cart in Firestore");
      } catch (e) {
        print("Failed to add product to cart: $e");
        // Handle error as needed
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.black,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onRemove,
                    iconSize: 18,
                    icon: const Icon(
                      Ionicons.remove_outline,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    currentNumber.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: onAdd,
                    iconSize: 18,
                    icon: const Icon(
                      Ionicons.add_outline,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: addToCart,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: kprimaryColor,
                  borderRadius: BorderRadius.circular(60),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
