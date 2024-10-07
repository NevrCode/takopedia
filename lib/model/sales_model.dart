class SalesModel {
  String salesDate;
  Map<String, dynamic> product;
  int price;
  int quantity;

  SalesModel({
    required this.salesDate,
    required this.product,
    required this.price,
    required this.quantity,
  });

  factory SalesModel.fromMap(Map<String, dynamic> data) {
    return SalesModel(
      salesDate: data['salesDate'] ?? '',
      product: data['product'] ?? {},
      price: data['price'] ?? 0,
      quantity: data['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'salesDate': salesDate,
      'product': product,
      'price': price,
      'quantity': quantity,
    };
  }
}
