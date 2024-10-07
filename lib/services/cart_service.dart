import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:takopedia/model/sales_model.dart';

class CartService {
  final CollectionReference _sales =
      FirebaseFirestore.instance.collection('sales');

  Future<void> addSales(SalesModel sales) async {
    await _sales
        .add({
          'date': sales.date,
          'product': sales.product,
          'quantity': sales.quantity,
          'user_id': sales.userId,
          'size': sales.size,
        })
        .then((value) => log("Sales Added"))
        .catchError((error) => log("Failed to add product: $error"));
  }

  Future<List<SalesModel>> fetchSales() async {
    try {
      QuerySnapshot snapshot = await _sales.get();
      return snapshot.docs.map((doc) {
        return SalesModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      log("Error : $e");
      return [];
    }
  }
}
