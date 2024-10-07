class SalesModel {
  String date;
  String userId;
  Map<String, dynamic> product;
  int quantity;
  String size;

  SalesModel({
    required this.date,
    required this.userId,
    required this.product,
    required this.quantity,
    required this.size,
  });

  factory SalesModel.fromMap(Map<String, dynamic> data) {
    return SalesModel(
      date: data['date'] ?? DateTime.timestamp(),
      userId: data['user_id'] ?? '',
      product: data['product'] ?? {},
      quantity: data['quantity'] ?? 0,
      size: data['size'] ?? 'no size',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'user_id': userId,
      'product': product,
      'quantity': quantity,
      'size': size,
    };
  }
}
