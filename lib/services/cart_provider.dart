import 'package:flutter/material.dart';
import 'package:takopedia/model/cart_model.dart';
import 'package:takopedia/services/cart_service.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> _cartItems = [];
  final _cartService = CartService();

  List<CartModel> get cartItems => _cartItems;

  void clearCart() {
    _cartItems = [];
    notifyListeners();
  }

  Future<void> fetchCartItem(String uid) async {
    final cartItem = await _cartService.fetchSales(uid);
    setCartItems(cartItem);
  }

  void setCartItems(List<CartModel> items) {
    _cartItems = items;
    notifyListeners(); // Notifies listeners (UI components) of changes
  }
}
