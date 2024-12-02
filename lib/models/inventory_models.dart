// lib/models/inventory_model.dart
class InventoryItem {
  final String id;
  final String name;
  final int quantity;
  final DateTime transactionDate;

  InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.transactionDate,
  });

  // Mengonversi objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'transactionDate': transactionDate.toIso8601String(),
    };
  }

  // Membuat objek dari JSON
  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      transactionDate: DateTime.parse(json['transactionDate']),
    );
  }
}
