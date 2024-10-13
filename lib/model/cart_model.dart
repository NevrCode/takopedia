import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  String productId;
  String userId;
  Map<String, dynamic> product;
  int quantity;
  String size;
  String ice;
  String sugar;

  CartModel(
      {required this.productId,
      required this.userId,
      required this.product,
      required this.quantity,
      required this.size,
      required this.ice,
      required this.sugar});

  // Map<String, dynamic> toMap() {
  //   return {
  //     'uid': userId,
  //     'product': product,
  //     'quantity': quantity,
  //     'size': size,
  //     'ice': ice,
  //     'sugar': sugar,
  //   };
  // }

  factory CartModel.fromDocument(DocumentSnapshot doc) {
    return CartModel(
      productId: doc.id,
      userId: doc['uid'] ?? '',
      product: doc['product'] ?? {},
      quantity: doc['quantity'] ?? 0,
      size: doc['size'] ?? 'regular',
      ice: doc['ice'] ?? 'normal',
      sugar: doc['sugar'] ?? 'normal',
    );
  }
}
