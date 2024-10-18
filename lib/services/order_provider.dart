import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:takopedia/model/cart_model.dart';
import 'package:takopedia/model/order_model.dart';
import 'package:takopedia/model/transaction_model.dart';

class OrderProvider with ChangeNotifier {
  final _transaction = FirebaseFirestore.instance.collection('transactions');
  final _order = FirebaseFirestore.instance.collection('orders');

  List<OrderModel> _orderModel = [];

  List<Transactions> _trans = [];
  List<Transactions> get trans => _trans;
  List<OrderModel> get order => _orderModel;

  Future<void> setTrans(List<Transactions> trans) async {
    _trans = trans;
    notifyListeners();
  }

  Future<void> setOrder(List<OrderModel> order) async {
    _orderModel = order;
    notifyListeners();
  }

  String generateRandomId(int length) {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }

  Future<void> fetchOrder(
    String uid,
  ) async {
    try {
      QuerySnapshot snapshot =
          await _transaction.where('uid', isEqualTo: uid).get();

      final trans = snapshot.docs.map((doc) {
        return Transactions.fromDocument(doc);
      }).toList();
      if (trans.isEmpty) {
        print('object');
      }
      setTrans(trans);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchOrderItem(String transactionID) async {
    try {
      QuerySnapshot snapshot =
          await _order.where('trans_id', isEqualTo: transactionID).get();

      final order = snapshot.docs.map((doc) {
        return OrderModel.fromDocument(doc);
      }).toList();

      if (order.isEmpty) {
        print('kosong ini order');
      }
      setOrder(order);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOrder(List<CartModel> carts, String deliveryType) async {
    String id = generateRandomId(15);
    final now = DateTime.now();
    for (var cart in carts) {
      await _transaction.doc(id).set({
        'uid': cart.userId,
        'cart': cart.id,
        'timestamp': now,
        'deliveryType': deliveryType,
      });
      Map<String, dynamic> mapped = cart.toMap();
      mapped.addAll({
        'trans_id': id,
      });
      await _order.doc(cart.id).set(mapped);
    }
    _trans.add(Transactions(
      transId: id,
      userId: carts[0].userId,
      cartId: carts[0].id,
      timestamp: now,
      deliveryType: deliveryType,
    ));
    notifyListeners();
  }
}
