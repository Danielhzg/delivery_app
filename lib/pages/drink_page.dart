import 'package:flutter/material.dart';
import 'package:delivery_app/item_details/item_detail_orangeJuice.dart';
import 'package:delivery_app/item_details/item_detail_icedKopi.dart';
import 'package:delivery_app/item_details/item_detail_cola.dart';
import 'package:delivery_app/item_details/item_detail_lemonade.dart';
import 'package:delivery_app/item_details/item_detail_milkTea.dart';
import 'package:delivery_app/item_details/item_detail_milkshake.dart';
import 'package:delivery_app/item_details/item_detail_thaitea.dart';
import 'package:delivery_app/item_details/item_detail_hotKopi.dart'; // Import ItemDetailHotKopi

class DrinkPage extends StatelessWidget {
  const DrinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final drinks = [
      {
        "name": "Orange Juice",
        "image": "assets/orange.jpeg",
        "page": const ItemDetailOrangeJuice(itemID: 1)
      },
      {
        "name": "Cola",
        "image": "assets/cola.jpeg",
        "page": const ItemDetailCola(itemID: 2)
      },
      {
        "name": "Iced Kopi",
        "image": "assets/icedKopi.jpg",
        "page": const ItemDetailIcedKopi(itemID: 3)
      },
      {
        "name": "Lemonade",
        "image": "assets/lemonade.jpeg",
        "page": const ItemDetailLemonade(itemID: 4)
      },
      {
        "name": "Milk Tea",
        "image": "assets/milkTea.jpeg",
        "page": const ItemDetailMilkTea(itemID: 5)
      },
      {
        "name": "Milkshake",
        "image": "assets/milkshake.jpeg",
        "page": const ItemDetailMilkshake(itemID: 6)
      },
      {
        "name": "Thai Tea",
        "image": "assets/ThaiTea.jpeg",
        "page": const ItemDetailThaiTea(itemID: 7)
      },
      {
        "name": "Hot Kopi",
        "image": "assets/hotKopi.png",
        "page": const ItemDetailHotKopi(itemID: 8)
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drinks Menu'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: drinks.length,
        itemBuilder: (context, index) {
          final drink = drinks[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => drink['page'] as Widget),
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
                      drink["image"] as String,
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
                      drink["name"] as String,
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
