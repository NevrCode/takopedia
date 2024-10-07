class SalesModel {
  String date;
  String userId;
  Map<String, dynamic> product;
  int price;
  int quantity;

  SalesModel({
    required this.date,
    required this.userId,
    required this.product,
    required this.price,
    required this.quantity,
  });

  factory SalesModel.fromMap(Map<String, dynamic> data) {
    return SalesModel(
      date: data['date'] ?? '',
      userId: data['user_id'],
      product: data['product'] ?? {},
      price: data['price'] ?? 0,
      quantity: data['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'user_id': userId,
      'product': product,
      'price': price,
      'quantity': quantity,
    };
  }
}
