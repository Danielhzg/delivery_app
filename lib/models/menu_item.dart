class MenuItem {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double price;
  final bool isPopular;
  final String description;

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.isPopular,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'price': price,
      'isPopular': isPopular,
      'description': description,
    };
  }

  factory MenuItem.fromMap(String id, Map<String, dynamic> data) {
    return MenuItem(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      isPopular: data['isPopular'] ?? false,
      description: data['description'] ?? '',
    );
  }
}
