class SalesModel {
  String date;
  String userId;
  Map<String, dynamic> product;
  int quantity;

  SalesModel({
    required this.date,
    required this.userId,
    required this.product,
    required this.quantity,
  });

  factory SalesModel.fromMap(Map<String, dynamic> data) {
    return SalesModel(
      date: data['date'] ?? DateTime.timestamp(),
      userId: data['user_id'] ?? '',
      product: data['product'] ?? {},
      quantity: data['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'user_id': userId,
      'product': product,
      'quantity': quantity,
    };
  }
}
