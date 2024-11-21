
import 'package:delivery_app/item_details/item_detail_noodlerice.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/item_details/item_detail_friedrice.dart';
import 'package:delivery_app/item_details/item_detail_chickenrice.dart';
import 'package:delivery_app/item_details/item_detail_specialrice.dart';

class RicePage extends StatelessWidget {
  const RicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final riceDishes = [
      {
        "name": "Fried Rice",
        "image": "assets/friedrice.jpeg",
        "page": const ItemDetailFriedRice(itemID: 1)
      },
      {
        "name": "Chicken Rice",
        "image": "assets/chickenrice.jpeg",
        "page": const ItemDetailChickenRice(itemID: 2)
      },
      {
        "name": "Noodle Rice",
        "image": "assets/noodlerice.jpeg",
        "page": const ItemDetailNoodleRice(itemID: 3)
      },
      {
        "name": "Special Rice",
        "image": "assets/specialrice.jpeg",
        "page": const ItemDetailSpecialRice(itemID: 4)
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rice Dishes Menu'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: riceDishes.length,
        itemBuilder: (context, index) {
          final riceDish = riceDishes[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => riceDish['page'] as Widget),
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
                      riceDish["image"] as String,
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
                      riceDish["name"] as String,
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