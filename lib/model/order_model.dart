import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:takopedia/model/cart_model.dart';

class OrderModel {
  String id;
  String userId;
  Map<String, dynamic> product;
  int quantity;
  String size;
  String ice;
  String sugar;

  OrderModel(
      {required this.id,
      required this.userId,
      required this.product,
      required this.quantity,
      required this.size,
      required this.ice,
      required this.sugar});

  factory OrderModel.fromDocument(DocumentSnapshot doc) {
    return OrderModel(
      id: doc.id,
      userId: doc['uid'] ?? '',
      product: doc['product'] ?? {},
      quantity: doc['quantity'] ?? 0,
      size: doc['size'] ?? 'regular',
      ice: doc['ice'] ?? 'normal',
      sugar: doc['sugar'] ?? 'normal',
    );
  }
}
