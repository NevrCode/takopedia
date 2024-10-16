import 'package:flutter/material.dart';
import 'package:takopedia/model/cart_model.dart';
import 'package:takopedia/services/cart_service.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> _cartItems = [];
  final _cartService = CartService();
  List<CartModel> get cartItems => _cartItems;

  Future<void> remove(String id) async {
    await _cartService.deleteProductFromCart(id);
    _cartItems.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> fetchCartItem(String uid) async {
    final cartItem = await _cartService.fetchSales(uid);
    setCartItems(cartItem);
  }

  Future<void> addItemToCart(CartModel cartItem) async {
    try {
      int existingItemIndex = _cartItems.indexWhere(
        (item) =>
            item.product['id'] == cartItem.product['id'] &&
            item.size == cartItem.size &&
            item.ice == cartItem.ice &&
            item.sugar == cartItem.sugar,
      );

      await _cartService.addCart(
        product: cartItem.product,
        quantity: cartItem.quantity,
        uid: cartItem.userId,
        size: cartItem.size,
        ice: cartItem.ice,
        sugar: cartItem.sugar,
      );
      if (existingItemIndex >= 0) {
        _cartItems[existingItemIndex].quantity++;
      } else {
        _cartItems.add(cartItem);
      }
      notifyListeners();
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  Future<void> add1(String uid, String productId) async {
    try {
      await _cartService.plus1Quantity(uid, productId);

      // Update local cart item
      var item =
          _cartItems.firstWhere((item) => item.product['id'] == productId);
      item.quantity++;
      notifyListeners();
    } catch (e) {
      print('Error updating cart item: $e');
    }
  }

  Future<void> min1(String uid, String productId) async {
    try {
      await _cartService.min1Quantity(uid, productId);

      // Update local cart item
      var item =
          _cartItems.firstWhere((item) => item.product['id'] == productId);
      item.quantity--;
      notifyListeners();
    } catch (e) {
      print('Error updating cart item: $e');
    }
  }

  void setCartItems(List<CartModel> items) {
    _cartItems = items;
    notifyListeners();
  }

  int get totalPrice {
    double total = 0.0;
    for (var i in _cartItems) {
      total += i.quantity * i.product['price'];
    }
    return total.toInt();
  }
}
