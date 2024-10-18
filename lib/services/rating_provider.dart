import 'package:flutter/material.dart';

class RatingProvider with ChangeNotifier {
  double? _rating = 0.0;
  String? _productId = '';
  double? get rating => _rating;
  String? get productID => _productId;

  void setRating(double star, String productId) {}
}
