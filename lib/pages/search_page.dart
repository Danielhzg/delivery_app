import 'package:delivery_app/item_details/item_detail_pizza.dart';
import 'package:flutter/material.dart';
import '../item_details/item_detail_burger.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // List of all items with types
  final List<Map<String, dynamic>> items = [
    {'id': 1, 'name': 'Burger', 'type': 'burger'},
    {'id': 2, 'name': 'Pizza', 'type': 'pizza'},
    {'id': 3, 'name': 'Burger with Cheese', 'type': 'burger'},
    {'id': 4, 'name': 'Hotdog', 'type': 'hotdog'},
    {'id': 5, 'name': 'Salad', 'type': 'salad'},
    {'id': 6, 'name': 'Chicken Burger', 'type': 'burger'},
  ];

  // List of filtered items
  List<Map<String, dynamic>> filteredItems = [];

  // To store the search query
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Initially, show all items
    filteredItems = items;
  }

  void _filterItems(String query) {
    setState(() {
      searchQuery = query;
      // Filter the list based on the query
      filteredItems = items
          .where((item) => item['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Items'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for items...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterItems, // Call the filter function on text input change
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return ListTile(
                  title: Text(item['name']!),
                  subtitle: Text('Item description here'),
                  onTap: () {
                    // Use the item's ID instead of the index for navigation
                    final itemId = item['id']; // Get the item ID
                    if (item['type'] == 'pizza') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetailPizza(itemId: itemId),
                        ),
                      );
                    } else if (item['type'] == 'burger') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetailBurger(itemId: itemId),
                        ),
                      );
                    } else {
                      // Handle other item types or show an error
                      print('Item type not handled');
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
