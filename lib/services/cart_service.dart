import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:takopedia/model/cart_model.dart';
import 'package:takopedia/model/sales_model.dart';

class CartService {
  final CollectionReference _cart =
      FirebaseFirestore.instance.collection('cart');

  Future<void> addCart(CartModel cart, uid, name) async {
    QuerySnapshot qs = await _cart
        .where('uid', isEqualTo: uid)
        .where('product.name', isEqualTo: name)
        .get();
    if (qs.docs.isEmpty) {
      await _cart
          .add({
            'product': cart.product,
            'quantity': cart.quantity,
            'uid': cart.userId,
            'size': cart.size,
            'ice': cart.ice,
            'sugar': cart.sugar,
          })
          .then((value) => log("Item Added to Cart"))
          .catchError((error) => log("Failed to add product: $error"));
    } else {
      plus1Quantity(uid, name);
    }
  }

  Future<List<CartModel>> fetchSales(String uid) async {
    try {
      QuerySnapshot snapshot = await _cart.get();
      List<CartModel> cartItem = [];
      final cartData = snapshot.docs.map((doc) {
        return CartModel.fromDocument(doc);
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

  Future<void> clearCart(String uid) async {
    try {
      QuerySnapshot qs = await _cart.where('user_id', isEqualTo: uid).get();
      if (qs.docs.isEmpty) {
        log("No documents found for this buyer ID.");
        return; // Exit if no documents found
      }

      for (QueryDocumentSnapshot doc in qs.docs) {
        await _cart
            .doc(doc.id)
            .delete()
            .then((value) => log("Shoes Deleted"))
            .catchError((e) => log(e));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> min1Quantity(String uid, String name) async {
    try {
      QuerySnapshot qs = await _cart
          .where('uid', isEqualTo: uid)
          .where('product.name', isEqualTo: name)
          .get();
      if (qs.docs.isEmpty) {
        log("No documents found for this buyer ID.");
        return;
      }

      await _cart
          .doc(qs.docs[0].id)
          .update({
            'quantity': qs.docs[0]['quantity'] - 1,
          })
          .then((value) => log("Shoes Deleted"))
          .catchError((e) => log(e));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> plus1Quantity(String uid, String name) async {
    try {
      QuerySnapshot qs = await _cart
          .where('uid', isEqualTo: uid)
          .where('product.name', isEqualTo: name)
          .get();
      if (qs.docs.isEmpty) {
        log("No documents found for this buyer ID.");
        return;
      }

      await _cart
          .doc(qs.docs[0].id)
          .update({
            'quantity': qs.docs[0]['quantity'] + 1,
          })
          .then((value) => log("Shoes Deleted"))
          .catchError((e) => log(e));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteProductFromCart(String uid, String name) async {
    try {
      QuerySnapshot qs = await _cart
          .where('uid', isEqualTo: uid)
          .where('product.name', isEqualTo: name)
          .get();
      if (qs.docs.isEmpty) {
        log("No documents found for this buyer ID.");
        return;
      }

      for (QueryDocumentSnapshot doc in qs.docs) {
        log('masuk');
        await _cart
            .doc(doc.id)
            .delete()
            .then((value) => log("Shoes Deleted"))
            .catchError((e) => log(e));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<int> getTotal(String uid) async {
    var item = await fetchSales(uid);
    int jml = 0;
    for (var i in item) {
      int x = i.product['price'];
      jml += x * i.quantity;
    }

    return jml;
  }

  // Stream<List<CartModel>> cartStream() {
  //   return _cart.snapshots();
  // }
}
