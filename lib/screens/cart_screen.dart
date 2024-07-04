import 'package:ecommerce_app/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../constants.dart';
import '../models/cart_item.dart';
import '../services/firestore_service.dart';
import '../widgets/cart_tile.dart';
import '../widgets/check_out_box.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartItem>> _cartItemsFuture;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _cartItemsFuture = _fetchCartItems();
  }

  Future<String?> _getCurrentUserId() async {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<List<CartItem>> _fetchCartItems() async {
    try {
      String? userId = await _getCurrentUserId();
      if (userId != null) {
        print('Fetching cart items for user: $userId');
        List<CartItem> items = await _firestoreService.getCartItems(userId);
        print('Fetched ${items.length} cart items');
        items.forEach((item) {
          print(
              'Cart item: id=${item.id}, productId=${item.productId}, quantity=${item.quantity}');
        });
        return items;
      } else {
        throw Exception('User ID not available');
      }
    } catch (e) {
      print('Failed to fetch cart items: $e');
      throw Exception('Failed to fetch cart items: $e');
    }
  }

  void removeItemFromCart(CartItem item) async {
    String? userId = await _getCurrentUserId();
    setState(() {
      _cartItemsFuture =
          _firestoreService.removeCartItem(userId!, item.id).then((_) {
        return _fetchCartItems(); // Refresh cart items after removal
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('${item.product?.title ?? 'Product'} removed from the cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcontentColor,
      appBar: AppBar(
        backgroundColor: kcontentColor,
        centerTitle: true,
        title: const Text(
          "My Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainScreen()));
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            icon: const Icon(Ionicons.chevron_back),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<CartItem>>(
          future: _cartItemsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Your cart is empty.'));
            } else {
              List<CartItem> cartItems = snapshot.data!;
              return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) => CartTile(
                  item: cartItems[index],
                  onRemove: () {
                    if (cartItems[index].quantity > 1) {
                      setState(() {
                        cartItems[index].quantity--;
                      });
                    }
                  },
                  onAdd: () {
                    setState(() {
                      cartItems[index].quantity++;
                    });
                  },
                  onDelete: () {
                    removeItemFromCart(cartItems[index]);
                  },
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemCount: cartItems.length,
              );
            }
          },
        ),
      ),
      bottomSheet: FutureBuilder<List<CartItem>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return SizedBox.shrink();
          } else {
            return CheckOutBox(
              items: snapshot.data!,
            );
          }
        },
      ),
    );
  }
}
