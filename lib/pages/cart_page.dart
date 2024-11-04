
import 'package:delivery_app/pages/home_page.dart';
import 'package:delivery_app/pages/profile_page.dart';
import 'package:delivery_app/pages/search_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Rute awal
      routes: {
        '/': (context) => HomePage(), // Rute untuk HomePage
        '/search': (context) => SearchPage(), // Rute untuk SearchPage
        '/cart': (context) => CartPage(), // Rute untuk CartPage
        '/profile': (context) => ProfilePage(), // Rute untuk ProfilePage
      },
    );
  }
}

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your Cart is Empty!',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigasi kembali ke HomePage
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: Text('Go Back to Shopping'),
          ),
        ],
      ),
    );
  }
}
