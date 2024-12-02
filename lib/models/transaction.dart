class Transaction {
  String id;
  String inventoryItemId;
  int quantity;
  DateTime createdAt;

  Transaction({required this.id, required this.inventoryItemId, required this.quantity, required this.createdAt});

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      inventoryItemId: map['inventoryItemId'],
      quantity: map['quantity'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'inventoryItemId': inventoryItemId,
      'quantity': quantity,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}