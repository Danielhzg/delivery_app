import 'package:flutter/material.dart';
import 'package:delivery_app/item_details/item_detail_margherita.dart';
import 'package:delivery_app/item_details/item_detail_pepperoni.dart';
import 'package:delivery_app/item_details/item_detail_bbqchicken.dart';
import 'package:delivery_app/item_details/item_detail_veggiepizza.dart';

class PizzaPage extends StatelessWidget {
  const PizzaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pizzas = [
      {
        "name": "Margherita",
        "image": "assets/margeritha.jpeg",
        "page": const ItemDetailMargherita(itemID: 1)
      },
      {
        "name": "Pepperoni",
        "image": "assets/peperoni.jpeg",
        "page": const ItemDetailPepperoni(itemID: 2)
      },
      {
        "name": "BBQ Chicken",
        "image": "assets/bbq.jpg",
        "page": const ItemDetailBBQChicken(itemID: 3)
      },
      {
        "name": "Veggie Pizza",
        "image": "assets/veggiepizza.jpeg",
        "page": const ItemDetailVeggiePizza(itemID: 4)
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizzas Menu'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: pizzas.length,
        itemBuilder: (context, index) {
          final pizza = pizzas[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => pizza['page'] as Widget),
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
                      pizza["image"] as String,
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
                      pizza["name"] as String,
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