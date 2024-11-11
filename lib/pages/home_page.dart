import 'dart:async';
import 'package:delivery_app/item_details/item_detail_burger.dart';
import 'package:delivery_app/item_details/item_detail_kopi.dart';
import 'package:delivery_app/item_details/item_detail_pizza.dart';
import 'package:delivery_app/item_details/item_detail_friedChicken.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  Timer? _timer;
  bool _isDarkTheme = false; // Variabel untuk tema

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      setState(() {
        _currentPage = (_currentPage + 1) % 2;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengganti tema
  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkTheme
          ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: AppBarTheme(backgroundColor: Colors.black),
            )
          : ThemeData.light().copyWith(
              scaffoldBackgroundColor: const Color(0xFFF4F6F9),
            ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopSection(),
              const SizedBox(height: 16),
              _buildMenuSection(),
              const SizedBox(height: 16),
              _buildPromoBannerSlider(),
              const SizedBox(height: 16),
              _buildPopularItemsSection(),
              const SizedBox(height: 16),
              _buildFreeDeliveryBanner(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/profile.png'),
                    radius: 15,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, Daniel',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        'Welcome to Spoon Kitchen',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _isDarkTheme ? Icons.wb_sunny : Icons.nightlight_round,
                  color: Colors.grey[700],
                ),
                onPressed: _toggleTheme, // Panggil fungsi untuk mengganti tema
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Search your food',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Icon(Icons.filter_list, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMenuItem('Pizza', Icons.local_pizza, Colors.orange),
          _buildMenuItem('Burger', Icons.fastfood, Colors.orange),
          _buildMenuItem('Drink', Icons.local_drink, Colors.orange),
          _buildMenuItem('Rice', Icons.rice_bowl, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            color: color == Colors.green ? Colors.green : Colors.black,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPromoBannerSlider() {
    return Column(
      children: [
        Container(
          height: 200,
          margin: const EdgeInsets.all(16),
          child: PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              _buildPromoBanner(
                  'assets/burger.jpeg', 'BURGER', 'Today\'s Hot offer'),
              _buildPromoBanner(
                  'assets/pizza.jpeg', 'PIZZA', 'Get it now with 10% off'),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              2, (index) => _buildIndicator(index == _currentPage)),
        ),
      ],
    );
  }

  Widget _buildPromoBanner(String imagePath, String title, String subtitle) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black45, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: const TextStyle(fontSize: 16, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.orange : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildPopularItemsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Popular Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPopularItemCard('assets/burger.jpeg', 'BURGER', '1'),
              _buildPopularItemCard('assets/pizza.jpeg', 'PIZZA', '2'),
              _buildPopularItemCard('assets/kopi.jpeg', 'KOPI', '3'),
              _buildPopularItemCard('assets/fried.jpeg', 'FRIED CHICKEN', '4'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularItemCard(String imagePath, String title, String itemId) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (title == 'BURGER') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ItemDetailBurger(itemID: 1),
              ),
            );
          } else if (title == 'PIZZA') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetailPizza(itemID: 2),
              ),
            );
          } else if (title == 'KOPI') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetailKopi(itemID: 3),
              ),
            );
          } else if (title == 'FRIED CHICKEN') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetailFriedChicken(itemID: 4),
              ),
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(imagePath, fit: BoxFit.cover, height: 130),
              ),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFreeDeliveryBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Center(
        child: Text(
          'Unlimited Free Delivery on your first month!',
          style: TextStyle(
              fontSize: 16, color: Colors.orange, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}