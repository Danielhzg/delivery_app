import 'package:flutter/material.dart';
import 'package:delivery_app/models/order.dart'; // Pastikan untuk mengimpor model Order
import 'package:delivery_app/pages/cart_page.dart'; // Pastikan untuk mengimpor CartPage

// Dummy data for Pizza
final pizza = Product(
  name: "Pizza Margherita",
  description: "Pizza klasik dengan saus tomat, mozzarella, dan basil segar.",
  imageUrl: "assets/pizza.jpeg",
  price: 8.00,
  rating: 4.7,
  reviews: "500+ Rating",
  discount: 20,
  location: "Bandung, Indonesia",
);

class Product {
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double rating;
  final String reviews;
  final int discount;
  final String location;

  Product({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.discount,
    required this.location,
  });
}

class ItemDetailPizza extends StatefulWidget {
  final int itemID;

  const ItemDetailPizza({super.key, required this.itemID});

  @override
  _ItemDetailPizzaState createState() => _ItemDetailPizzaState();
}

class _ItemDetailPizzaState extends State<ItemDetailPizza> {
  int quantity = 1;
  double deliveryFee = 3.00;

  double get subtotal => pizza.price * quantity;
  double get payableTotal => subtotal + deliveryFee;

  void _confirmOrder() {
    Order newOrder = Order(
      productName: pizza.name,
      quantity: quantity,
      total: payableTotal,
    );

    orders.add(newOrder); // Menambahkan pesanan ke daftar global

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pesanan Berhasil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pesanan Anda telah berhasil dibuat!'),
              const SizedBox(height: 8),
              const Text('Detail pesanan:'),
              Text('${pizza.name} x $quantity'),
              Text('Total: \$${payableTotal.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
              child: const Text('Lihat Keranjang'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
              },
              child: const Text('Selesai'),
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
        title: const Text('Detail Pizza'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    pizza.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${pizza.discount}% OFF",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(pizza.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text("${pizza.rating} (${pizza.reviews})"),
                ],
              ),
              const SizedBox(height: 8),
              Text("\$${pizza.price}", style: const TextStyle(fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => setState(() {
                      if (quantity > 1) quantity--;
                    }),
                  ),
                  Text(quantity.toString()),
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
                  Text(pizza.location),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const Text("Ringkasan Checkout", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  const Text("Biaya Pengiriman"),
                  Text("\$${deliveryFee.toStringAsFixed(2)}"),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total yang Harus Dibayar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("\$${payableTotal.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.orange),
                  onPressed: _confirmOrder,
                  child: const Text("Konfirmasi Pesanan", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}