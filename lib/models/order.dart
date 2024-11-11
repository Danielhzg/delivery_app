// order.dart
class Order {
  final String productName;
  final int quantity;
  final double total;

  Order({
    required this.productName,
    required this.quantity,
    required this.total,
  });
}

// Global list to store orders
List<Order> orders = [];