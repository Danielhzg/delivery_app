import 'package:flutter/material.dart';
import 'package:delivery_app/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<CartOrder> orders = [];

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String selectedPaymentMethod = 'Tunai'; // Default payment method
  final user = FirebaseAuth.instance.currentUser;

  double get totalAmount => orders.fold(0.0, (total, order) => total + order.total);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Anda')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartItems = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return CartOrder(
              productName: data['name'],
              quantity: data['quantity'],
              total: data['price'] * data['quantity'],
              unitPrice: data['price'],
              imageUrl: data['imageUrl'],
            );
          }).toList();

          return cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(cartItems);
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return const Center(child: Text('Keranjang Anda kosong.'));
  }

  Widget _buildCartContent(List<CartOrder> cartItems) {
    return Column(
      children: [
        Expanded(child: ListView.builder(itemCount: cartItems.length, itemBuilder: (context, index) => _buildOrderCard(context, index, cartItems))),
        const Divider(),
        _buildTotalAmountDisplay(cartItems),
        _buildCheckoutButton(),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, int index, List<CartOrder> cartItems) {
    final order = cartItems[index];
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildOrderImage(order.imageUrl),
            const SizedBox(width: 16),
            Expanded(child: _buildOrderDetails(order)),
            _buildDeleteButton(index, cartItems[index]),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderImage(String imageUrl) {
    final decodedUrl = Uri.decodeComponent(imageUrl);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: decodedUrl.startsWith('http')
          ? Image.network(decodedUrl, width: 80, height: 80, fit: BoxFit.cover)
          : Image.asset(decodedUrl, width: 80, height: 80, fit: BoxFit.cover),
    );
  }

  Widget _buildOrderDetails(CartOrder order) {
    return Flexible(
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

  Widget _buildDeleteButton(int index, CartOrder order) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () => _deleteOrder(index, order),
    );
  }

  Widget _buildTotalAmountDisplay(List<CartOrder> cartItems) {
    final totalAmount = cartItems.fold(0.0, (total, order) => total + order.total);
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

  void _processCheckout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartCollection = FirebaseFirestore.instance.collection('cart');
      final querySnapshot = await cartCollection.where('userId', isEqualTo: user.uid).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    }

    setState(() {
      orders.clear(); // Clear orders after checkout
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Checkout berhasil dengan $selectedPaymentMethod')),
    );
  }

  void _deleteOrder(int index, CartOrder order) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('userId', isEqualTo: user.uid)
          .where('name', isEqualTo: order.productName)
          .where('price', isEqualTo: order.unitPrice)
          .where('imageUrl', isEqualTo: order.imageUrl)
          .limit(1)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      setState(() {
        orders.removeAt(index); // Remove the order from the list
      });
    }
  }
}