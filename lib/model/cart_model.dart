class CartModel {
  String userId;
  Map<String, dynamic> product;
  int quantity;
  String size;

  CartModel({
    required this.userId,
    required this.product,
    required this.quantity,
    required this.size,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'product': product,
      'quantity': quantity,
      'size': size,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> data) {
    return CartModel(
      userId: data['user_id'] ?? '',
      product: data['product'] ?? {},
      quantity: data['quantity'] ?? 0,
      size: data['size'] ?? 'no size',
    );
  }
}
