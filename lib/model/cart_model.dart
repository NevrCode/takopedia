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
}
