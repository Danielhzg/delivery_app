import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/categories.dart';
import 'category_menu_page.dart';

void main() {
  runApp(MyApp()); // Remove const keyword
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spoon Kitchen',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF9800),
          primary: const Color(0xFFFF9800),
          secondary: const Color(0xFFFFB74D),
          tertiary: const Color(0xFFFFCC80),
          background: const Color(0xFFFFF3E0),
          surface: const Color(0xFFFFE0B2),
        ),
        scaffoldBackgroundColor:
            const Color(0xFFFFF3E0), // Main background color
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF9800),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(color: Color(0xFFE65100)),
          bodyLarge: TextStyle(color: Color(0xFFF57C00)),
          bodyMedium: TextStyle(color: Color(0xFFFF9800)),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  Timer? _timer;
  late Stream<DocumentSnapshot> _userStream;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    // Initialize user stream with empty stream as default
    final userId = FirebaseAuth.instance.currentUser?.uid;
    _userStream = userId != null
        ? FirebaseFirestore.instance.collection('users').doc(userId).snapshots()
        : const Stream.empty();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // Explicit background color
      body: SafeArea(
        child: Container(
          color: const Color(0xFFFFF3E0), // Container background
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildTopSection()),
              SliverToBoxAdapter(child: _buildMenuSection()),
              SliverToBoxAdapter(child: _buildPromoBannerSlider()),
              SliverToBoxAdapter(child: _buildPopularItemsSection()),
              SliverToBoxAdapter(child: _buildFreeDeliveryBanner()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return StreamBuilder<DocumentSnapshot>(
      stream: _userStream,
      builder: (context, snapshot) {
        String firstName = 'Guest';
        if (snapshot.hasData && snapshot.data != null) {
          final userData = snapshot.data!.data() as Map<String, dynamic>?;
          firstName = userData?['firstName'] ?? 'Guest';
        }

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF9800).withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.person_rounded,
                              size: 30,
                              color: const Color(0xFFFF9800).withOpacity(0.7),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      const Color(0xFFFF9800).withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, $firstName',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white70),
                          ),
                          const Text(
                            'Welcome to Spoon Kitchen',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      // Navigate to cart page
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search your food',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: const Icon(Icons.filter_list, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),  
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuSection() {
    return Container(
      color: const Color(0xFFFFF3E0),
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: menuCategories.map((category) {
          return _buildMenuItem(
            category['name'],
            category['icon'],
            const Color(0xFFFF9800),
          );
        }).toList(),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'pizza':
        return Icons.local_pizza;
      case 'burger':
        return Icons.lunch_dining;
      case 'drink':
        return Icons.local_drink;
      case 'rice':
        return Icons.rice_bowl;
      default:
        return Icons.restaurant;
    }
  }

  Widget _buildMenuItem(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryMenuPage(
              category: title,
              categoryIcon: icon,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: color, size: 35),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBannerSlider() {
    final promos = [
      ('assets/burger.jpeg', 'BURGER', "Today's Hot Offer"),
      ('assets/pizza.jpeg', 'PIZZA', 'Get it now with 10% off'),
    ];

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: promos.length,
            itemBuilder: (context, index) {
              final promo = promos[index];
              return _buildPromoBanner(promo.$1, promo.$2, promo.$3);
            },
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            promos.length,
            (index) => _buildIndicator(index == _currentPage),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoBanner(String imagePath, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE65100) : const Color(0xFFFFCC80),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildPopularItemsSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('menu')
          .where('isPopular', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final popularItems = snapshot.data!.docs
            .map((doc) =>
                MenuItem.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Popular Items',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE65100),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularItems.length,
                  itemBuilder: (context, index) {
                    final item = popularItems[index];
                    return _buildPopularItemCard(
                      item.imageUrl,
                      item.name,
                      item.id,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopularItemCard(String imagePath, String title, String itemId) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white, // Card background back to white
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9800).withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            child: Stack(
              children: [
                Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  height: 130,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 130),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Color(0xFFFF9800),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE65100),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Item #$itemId',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFFF9800),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9800).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Popular',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9800),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFreeDeliveryBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE65100),
            Color(0xFFFF9800),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9800).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.local_shipping, color: Colors.white, size: 48),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              'Unlimited Free Delivery on your first month!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final double price;
  final bool isPopular;
  final String description;

  MenuItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.price,
    this.isPopular = false,
    this.description = '',
  });

  factory MenuItem.fromMap(String id, Map<String, dynamic> data) {
    return MenuItem(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      isPopular: data['isPopular'] ?? false,
      description: data['description'] ?? '',
    );
  }
}
