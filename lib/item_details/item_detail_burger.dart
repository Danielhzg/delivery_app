import 'package:flutter/material.dart';

// Dummy data for demonstration
class Burger {
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final List<String> features;

  Burger({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.features,
  });
}

//  burger data
final Burger burger = Burger(
  name: "Delicious Burger",
  description: "A juicy burger with fresh ingredients and a delicious taste.",
  imageUrl: "assets/burger.jpeg",
  price: 8.00,
  features: [
    "100% Beef Patty",
    "Fresh Lettuce",
    "Tomato & Onion",
    "Cheddar Cheese",
    "Special Sauce",
  ],
);

// Item Detail Page for Burger
class ItemDetailBurger extends StatelessWidget {
  final int itemId; // Assuming you want to pass itemId

  ItemDetailBurger({required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(burger.name),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Section
            Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(burger.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Product Details Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        burger.name,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$${burger.price.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // Description
                  Text(
                    burger.description,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: 16),

                  // Features List
                  Text(
                    "Features:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...burger.features.map((feature) => _buildFeatureItem(feature)).toList(),

                  SizedBox(height: 20),

                  // Add to Cart Button
                  ElevatedButton(
                    onPressed: () {
                      // Implement add to cart functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${burger.name} added to cart")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent, // Use backgroundColor instead of primary
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text("Add to Cart"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check, color: Colors.green),
          SizedBox(width: 8),
          Text(feature, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
