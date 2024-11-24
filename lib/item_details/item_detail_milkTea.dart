import 'package:flutter/material.dart';
import 'package:delivery_app/models/order.dart'; // Import model Order
import 'package:delivery_app/models/product.dart'; // Import model Product
import 'package:delivery_app/pages/cart_page.dart'; // Import CartPage

// Dummy data for Milk Tea
final milkTea = Product(
  id: "5",
  name: "Milk Tea",
  description: "Teh susu dengan rasa manis dan segar.",
  imageUrl: "assets/milkTea.jpeg",
  price: 3.50,
  rating: 4.6,
  reviews: "250+ Rating",
  discount: 0,
  location: "Yogyakarta, Indonesia",
);

class ItemDetailMilkTea extends StatefulWidget {
  final int itemID;

  const ItemDetailMilkTea({super.key, required this.itemID});

  @override
  _ItemDetailMilkTeaState createState() => _ItemDetailMilkTeaState();
}

class _ItemDetailMilkTeaState extends State<ItemDetailMilkTea> {
  int quantity = 1;
  double deliveryFee = 2.00;

  double get subtotal => milkTea.price * quantity;
  double get payableTotal => subtotal + deliveryFee;

  void _confirmOrder() {
    Order newOrder = Order(
      productName: milkTea.name,
      quantity: quantity,
      total: payableTotal,
      unitPrice: milkTea.price,
      imageUrl: milkTea.imageUrl,
    );

    orders.add(newOrder);

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
              Text('${milkTea.name} x $quantity'),
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
              child: const Text('Lihat Keranjang'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
        title: const Text('Detail Milk Tea'),
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
                    tag: milkTea.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        milkTea.imageUrl,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (milkTea.discount > 0)
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
                          "${milkTea.discount}% OFF",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(milkTea.name,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text("${milkTea.rating} (${milkTea.reviews})"),
                ],
              ),
              const SizedBox(height: 8),
              Text("\$${milkTea.price}",
                  style: const TextStyle(
                      fontSize: 24,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(milkTea.description,
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
                  Text(milkTea.location),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const Text("Ringkasan Checkout",
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
                  const Text("Biaya Pengiriman"),
                  Text("\$${deliveryFee.toStringAsFixed(2)}"),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total yang Harus Dibayar",
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
                  child: const Text("Konfirmasi Pesanan",
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