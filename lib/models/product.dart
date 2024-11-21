// product.dart
class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double rating;
  final String reviews;
  final int discount;
  final String location;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.discount,
    required this.location,
  });
}