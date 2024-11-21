import 'package:flutter/material.dart';
import 'package:delivery_app/models/order.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String selectedPaymentMethod = 'Tunai'; // Default payment method

  double get totalAmount => orders.fold(0.0, (total, order) => total + order.total);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Anda')),
      body: orders.isEmpty ? _buildEmptyCart() : _buildCartContent(),
    );
  }

  Widget _buildEmptyCart() {
    return const Center(child: Text('Keranjang Anda kosong.'));
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(child: ListView.builder(itemCount: orders.length, itemBuilder: _buildOrderCard)),
        const Divider(),
        _buildTotalAmountDisplay(),
        _buildCheckoutButton(),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, int index) {
    final order = orders[index];
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildOrderImage(order.imageUrl),
            const SizedBox(width: 16),
            _buildOrderDetails(order),
            _buildDeleteButton(index),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(imageUrl, width: 80, height: 80, fit: BoxFit.cover),
    );
  }

  Widget _buildOrderDetails(Order order) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(order.productName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("Jumlah: ${order.quantity}", style: const TextStyle(color: Colors.grey)),
          Text("\$${order.total.toStringAsFixed(2)}", style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(int index) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () => _deleteOrder(index),
    );
  }

  Widget _buildTotalAmountDisplay() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Total Pembayaran", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("\$${totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return ElevatedButton(
      onPressed: _checkout,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.orange,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text('Bayar Sekarang', style: TextStyle(color: Colors.white)),
    );
  }

  void _checkout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Checkout'),
          content: _buildPaymentMethodSelector(),
          actions: _buildDialogActions(),
        );
      },
    );
  }

  Widget _buildPaymentMethodSelector() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Pilih metode pembayaran:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ..._buildPaymentOptions(setState),
            const SizedBox(height: 10),
            Text('Metode yang dipilih: $selectedPaymentMethod', style: const TextStyle(fontSize: 16)),
          ],
        );
      },
    );
  }

  List<Widget> _buildPaymentOptions(StateSetter setState) {
    const options = [
      {'method': 'Gopay', 'icon': 'assets/gopay.jpeg'},
      {'method': 'OVO', 'icon': 'assets/ovo.jpeg'},
      {'method': 'ShopePay', 'icon': 'assets/shopeepay.jpeg'},
    ];
    return options.map((option) {
      return _buildPaymentOption(option['method']!, option['icon']!, setState);
    }).toList();
  }

  Widget _buildPaymentOption(String method, String iconPath, StateSetter setState) {
    return GestureDetector(
      onTap: () {
        setState(() => selectedPaymentMethod = method);
      },
      child: Container(
        decoration: BoxDecoration(
          color: selectedPaymentMethod == method ? Colors.orange[100] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ListTile(
          title: Text(method),
          leading: Image.asset(iconPath, width: 30, height: 30),
          trailing: Radio<String>(
            value: method,
            groupValue: selectedPaymentMethod,
            onChanged: (value) {
              setState(() => selectedPaymentMethod = value!);
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDialogActions() {
    return [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          _processCheckout();
        },
        child: const Text('Checkout'),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Batal'),
      ),
    ];
  }

  void _processCheckout() {
    setState(() {
      orders.clear(); // Clear orders after checkout
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Checkout berhasil dengan $selectedPaymentMethod')),
    );
  }

  void _deleteOrder(int index) {
    setState(() {
      orders.removeAt(index); // Remove the order from the list
    });
  }
}