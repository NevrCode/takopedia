import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:takopedia/model/sales_model.dart';
import 'package:takopedia/model/cart_model.dart';

class CartService {
  final CollectionReference _sales =
      FirebaseFirestore.instance.collection('sales');
  final CollectionReference _cart =
      FirebaseFirestore.instance.collection('cart');

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

  Future<void> addToCart(CartModel cartItem) async {
    await _cart
        .add({
          'user_id': cartItem.userId,
          'product': cartItem.product,
          'quantity': cartItem.quantity,
          'size': cartItem.size
        })
        .then((value) => log("Cart added"))
        .catchError((error) => log("Failed to add to cart; $error"));
  }

  Future<void> removeCart(String uid) async {
    Query query = _cart.where("user_id", isEqualTo: uid);
    QuerySnapshot snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      log('Document(s) with uid $uid deleted');
    } else {
      log('No document found with uid $uid');
    }
  }

  Future<List<SalesModel>> fetchSales(String uid) async {
    try {
      QuerySnapshot snapshot = await _sales.get();
      List<SalesModel> cartItem = [];
      final cartData = snapshot.docs.map((doc) {
        return SalesModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      for (var element in cartData) {
        if (element.userId == uid) {
          cartItem.add(element);
        }
      }
      return cartItem;
    } catch (e) {
      log("Error : $e");
      return [];
    }
  }

  Future<List<CartModel>> fetchCart(String uid) async {
    try {
      QuerySnapshot snapshot = await _cart.get();
      List<CartModel> cartItem = [];
      final cartData = snapshot.docs.map((doc) {
        log(doc.data().toString());
        return CartModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      for (var element in cartData) {
        if (element.userId == uid) {
          cartItem.add(element);
        }
      }
      return cartItem;
    } catch (e) {
      log("Error : $e");
      return [];
    }
  }
}
