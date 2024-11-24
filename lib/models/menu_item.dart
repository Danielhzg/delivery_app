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
    this.isPopular = false,
    this.description = '',
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

  factory MenuItem.fromMap(String id, Map<String, dynamic> map) {
    return MenuItem(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      isPopular: map['isPopular'] ?? false,
      description: map['description'] ?? '',
    );
  }
}
