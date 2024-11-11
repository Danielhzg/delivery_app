import 'package:flutter/material.dart';
import 'package:delivery_app/models/order.dart'; // Pastikan untuk mengimpor model Order

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keranjang Anda"),
      ),
      body: orders.isEmpty
          ? const Center(child: Text("Keranjang Anda kosong."))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  title: Text(order.productName),
                  subtitle: Text("Jumlah: ${order.quantity}"),
                  trailing: Text("\$${order.total.toStringAsFixed(2)}"),
                );
              },
            ),
    );
  }
}