import 'package:flutter/material.dart';
import 'package:delivery_app/item_details/item_detail_cheeseburger.dart';
import 'package:delivery_app/item_details/item_detail_chickenburger.dart';
import 'package:delivery_app/item_details/item_detail_veggieburger.dart';
import 'package:delivery_app/item_details/item_detail_doubleburger.dart';

class BurgerPage extends StatelessWidget {
  const BurgerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final burgers = [
      {
        "name": "Cheeseburger",
        "image": "assets/cheeseBurger.jpeg",
        "page": const  ItemDetailCheeseburger(itemID: 1)
      },
      {
        "name": "Chicken Burger",
        "image": "assets/chickenBurger.jpeg",
        "page": const ItemDetailChickenBurger(itemID: 2)
      },
      {
        "name": "Veggie Burger",
        "image": "assets/veggieBurger.jpeg",
        "page": const ItemDetailVeggieBurger(itemID: 3)
      },
      {
        "name": "Double Burger",
        "image": "assets/doubleBurger.jpeg",
        "page": const ItemDetailDoubleBurger(itemID: 4)
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Burgers Menu'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: burgers.length,
        itemBuilder: (context, index) {
          final burger = burgers[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => burger['page'] as Widget),
              );
            },
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      burger["image"] as String,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Text(
                      burger["name"] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
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
