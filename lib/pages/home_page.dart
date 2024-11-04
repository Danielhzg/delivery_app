import 'dart:async'; // Import Timer
import 'package:delivery_app/item_details/item_detail_burger.dart';
import 'package:delivery_app/item_details/item_detail_pizza.dart';
import 'package:flutter/material.dart';

// Main Home Page
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  Timer? _timer;
  Timer? _flashSaleTimer;
  Duration _flashSaleDuration = Duration(hours: 2, minutes: 0, seconds: 0); // Set initial duration

  @override
  void initState() {
    super.initState();

    // Timer untuk auto-slide
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });

    // Timer untuk flash sale countdown
    _flashSaleTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_flashSaleDuration.inSeconds > 0) {
          _flashSaleDuration = Duration(seconds: _flashSaleDuration.inSeconds - 1);
        } else {
          timer.cancel(); // Stop timer when countdown reaches zero
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Matikan timer saat tidak diperlukan
    _flashSaleTimer?.cancel(); // Stop flash sale timer
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F6F9), // Light background
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Promo Banner Section
            Container(
              height: 200,
              margin: EdgeInsets.all(16),
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildPromoBanner('assets/burger.jpeg', 'SALE UP TO 50%', 'Grab them now!'),
                  _buildPromoBanner('assets/pizza.jpeg', 'Best Deals', 'Exclusive offers for you!'),
                  _buildPromoBanner('assets/kopi.jpeg', 'Limited Time Offer', 'Don\'t miss out!'),
                ],
              ),
            ),
            SizedBox(height: 8),

            // Indicator for Promo Banner
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => _buildIndicator(index == _currentPage)),
            ),

            const SizedBox(height: 16),

            // Category Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                CategoryCard('Vegetables', 'assets/burger.jpeg'),
                CategoryCard('Fruits', 'assets/burger.jpeg'),
                CategoryCard('Herbs', 'assets/icons/herbs.png'),
                CategoryCard('Beverages', 'assets/icons/beverages.png'),
                CategoryCard('Promo', 'assets/icons/promo.png'),
                CategoryCard('Best Seller', 'assets/icons/bestseller.png'),
                CategoryCard('Protein', 'assets/icons/protein.png'),
                CategoryCard('Green', 'assets/icons/green.png'),
              ],
            ),
            SizedBox(height: 16),

            // Flash Sale Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Flash Sale',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // Display the remaining time
                  Text(
                    _formatDuration(_flashSaleDuration),
                    style: TextStyle(fontSize: 16, color: Colors.redAccent),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 250,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  FlashSaleItem(
                    'Pizza',
                    'assets/pizza.jpeg',
                    '\$10.00',
                    'Best Seller',
                    'Save 20%',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ItemDetailPizza(itemId: 1)),
                      );
                    },
                  ),
                  FlashSaleItem(
                    'Burger',
                    'assets/burger.jpeg',
                    '\$8.00',
                    'Best Seller',
                    'Save 15%',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ItemDetailBurger(itemId: 2)),
                      );
                    },
                  ),
                  FlashSaleItem(
                    'Kale',
                    'assets/kopi.jpeg',
                    '\$1.80/kg',
                    'Best Seller',
                    'Save 15%',
                    onTap: () {
                      // Add your navigation here if you create a detail page for Kale
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Format duration to display
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  // Promo Banner Widget
  Widget _buildPromoBanner(String imagePath, String title, String subtitle) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black26, Colors.transparent],
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
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  color: Colors.orangeAccent,
                  child: Text(
                    'END YEAR SALE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Indicator Widget for Banner
  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.orangeAccent : Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

// CategoryCard Widget
class CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const CategoryCard(this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(10),
            child: Image.asset(imageUrl, height: 40, width: 40),
          ),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// Flash Sale Item Widget
class FlashSaleItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String price;
  final String badgeText;
  final String discountText;
  final VoidCallback onTap;

  const FlashSaleItem(this.title, this.imageUrl, this.price, this.badgeText, this.discountText, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.all(8),
        child: Container(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      color: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                      child: Text(
                        badgeText,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(price, style: TextStyle(fontSize: 14, color: Colors.green)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(discountText, style: TextStyle(fontSize: 12, color: Colors.redAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}