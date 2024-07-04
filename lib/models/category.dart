import 'package:ecommerce_app/screens/main_screen.dart';
import 'package:flutter/material.dart';

import '../screens/product-screens/shoes.dart'; // Import your screen widgets

class Category {
  final String title;
  final String image;

  Category({
    required this.title,
    required this.image,
  });
}

// List of categories
final List<Category> categories = [
  Category(title: "Shoes", image: "assets/shoes.jpg"),
  //Category(title: "Beauty", image: "assets/beauty.png"),
  Category(title: "PC", image: "assets/pc.jpg"),
  Category(title: "Mobile", image: "assets/mobile.jpg"),
  Category(title: "Watch", image: "assets/watch.png"),
];

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120, // Adjust the height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          // Determine the destination page based on the category
          Widget destinationPage;
          switch (category.title) {
            case "Shoes":
              destinationPage = Shoes(); // Use your actual destination pages
              break;
            case "PC":
              destinationPage = Scaffold();
              break;
            case "Mobile":
              destinationPage = Scaffold();
              break;
            case "Watch":
              destinationPage = Scaffold();
              break;
            default:
              destinationPage = MainScreen(); // Fallback or default page
          }

          return InkWell(
            onTap: () {
              // Navigate to the selected category page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destinationPage),
              );
            },
            child: Container(
              width: 100, // Adjust the width as needed
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(category.image,
                      fit: BoxFit.cover, height: 60, width: 60),
                  SizedBox(height: 8),
                  Text(
                    category.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
