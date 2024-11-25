import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryMenuPage extends StatelessWidget {
  final String category;
  final IconData categoryIcon;

  const CategoryMenuPage({
    super.key,
    required this.category,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: Text(category),
        backgroundColor: const Color(0xFFFF9800),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('menu')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(categoryIcon, size: 64, color: const Color(0xFFFF9800)),
                  const SizedBox(height: 16),
                  Text(
                    'No $category items available yet',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFFF9800),
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index].data() as Map<String, dynamic>;
              return _buildMenuItemCard(item);
            },
          );
        },
      ),
    );
  }

  Widget _buildMenuItemCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9800).withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: item['imageUrl'].startsWith('data:image')
                  ? Image.memory(
                      Uri.parse(item['imageUrl']).data!.contentAsBytes(),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Image.network(
                      item['imageUrl'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFFE65100),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item['price']}',
                    style: const TextStyle(
                      color: Color(0xFFFF9800),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
