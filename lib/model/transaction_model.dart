import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  String userId;
  String transId;
  DateTime timestamp;
  String deliveryType;
  int price;

  Transactions({
    required this.transId,
    required this.userId,
    required this.timestamp,
    required this.deliveryType,
    required this.price,
  });

  factory Transactions.fromDocument(DocumentSnapshot doc) {
    return Transactions(
      userId: doc['uid'] ?? '',
      transId: doc.id,
      deliveryType: doc['deliveryType'] ?? 'Take Away',
      timestamp: doc['timestamp'].toDate() ?? DateTime.now(),
      price: doc['price'] ?? 0,
    );
  }
}
