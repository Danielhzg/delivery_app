
import 'package:flutter/material.dart';
import 'package:delivery_app/models/order.dart'; // Import model Order
import 'package:delivery_app/models/product.dart'; // Import model Product
import 'package:delivery_app/pages/cart_page.dart'; // Import CartPage

// Dummy data for Chicken Rice
final chickenRice = Product(
  id: "2",
  name: "Chicken Rice",
  description: "Tasty chicken rice with a blend of spices.",
  imageUrl: "assets/chickenrice.jpeg",
  price: 6.00,
  rating: 4.7,
  reviews: "150+ Rating",
  discount: 0,
  location: "Bandung, Indonesia",
);

class ItemDetailChickenRice extends StatefulWidget {
  final int itemID;

  const ItemDetailChickenRice({super.key, required this.itemID});

  @override
  _ItemDetailChickenRiceState createState() => _ItemDetailChickenRiceState();
}

class _ItemDetailChickenRiceState extends State<ItemDetailChickenRice> {
  int quantity = 1;
  double deliveryFee = 2.50;

  double get subtotal => chickenRice.price * quantity;
  double get payableTotal => subtotal + deliveryFee;

  void _confirmOrder() {
    Order newOrder = Order(
      productName: chickenRice.name,
      quantity: quantity,
      total: payableTotal,
      unitPrice: chickenRice.price,
      imageUrl: chickenRice.imageUrl,
    );

    orders.add(newOrder);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your order has been placed successfully!'),
              const SizedBox(height: 8),
              const Text('Order details:'),
              Text('${chickenRice.name} x $quantity'),
              Text('Total: \$${payableTotal.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
              child: const Text('View Cart'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chicken Rice Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: chickenRice.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        chickenRice.imageUrl,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (chickenRice.discount > 0)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${chickenRice.discount}% OFF",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(chickenRice.name,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text("${chickenRice.rating} (${chickenRice.reviews})"),
                ],
              ),
              const SizedBox(height: 8),
              Text("\$${chickenRice.price}",
                  style: const TextStyle(
                      fontSize: 24,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(chickenRice.description,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => setState(() {
                      if (quantity > 1) quantity--;
                    }),
                  ),
                  Text(quantity.toString(),
                      style: const TextStyle(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() {
                      quantity++;
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.deepPurple),
                  const SizedBox(width: 8),
                  Text(chickenRice.location),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const Text("Checkout Summary",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Subtotal ($quantity)"),
                  Text("\$${subtotal.toStringAsFixed(2)}"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Delivery Fee"),
                  Text("\$${deliveryFee.toStringAsFixed(2)}"),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Payable",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("\$${payableTotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.orange),
                  onPressed: _confirmOrder,
                  child: const Text("Confirm Order",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}