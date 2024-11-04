import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Track the selected index for bottom navigation

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // Show the currently selected page
        children: [
          // Home Page
          SingleChildScrollView(
            child: Column(
              children: [
                // Banner Promo
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/800x200?text=Promo+Banner'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Special Offers!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.black54,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Kategori Makanan
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Food Categories',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryCard('Pizza', 'https://via.placeholder.com/100?text=Pizza'),
                      CategoryCard('Burgers', 'https://via.placeholder.com/100?text=Burgers'),
                      CategoryCard('Sushi', 'https://via.placeholder.com/100?text=Sushi'),
                      CategoryCard('Salads', 'https://via.placeholder.com/100?text=Salads'),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Daftar Item Makanan
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Popular Dishes',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return FoodCard(index);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Second page example (e.g., Search Page)
          Center(child: Text("Search Page")),
          // Third page example (e.g., Cart Page)
          Center(child: Text("Cart Page")),
          // Fourth page example (e.g., Profile Page)
          Center(child: Text("Profile Page")),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white, // Warna putih untuk ikon yang dipilih
        unselectedItemColor: Colors.black, // Warna hitam untuk ikon yang tidak dipilih
        backgroundColor: Colors.orange, // Warna latar belakang oranye
        onTap: _onItemTapped,
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const CategoryCard(this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Image.network(imageUrl, height: 60, width: 60, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title),
          ),
        ],
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final int index;

  FoodCard(this.index);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network('https://via.placeholder.com/150?text=Food+$index', height: 120, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Food Item $index',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Description for food item $index'),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                // Tambahkan fungsi untuk menambah ke keranjang
              },
              child: Text('Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }
}
