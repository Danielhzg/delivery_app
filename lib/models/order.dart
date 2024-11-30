// order.dart
class CartOrder {
  String productName;
  int quantity;
  double total;
  double unitPrice; // Price per unit
  String imageUrl;

  CartOrder({
    required this.productName,
    required this.quantity,
    required this.total,
    required this.unitPrice,
    required this.imageUrl,
  });
}

// Global list to store orders
List<CartOrder> orders = [];
