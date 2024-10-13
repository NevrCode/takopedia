import 'package:flutter/material.dart';
import 'package:takopedia/model/product_model.dart';
import 'package:takopedia/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _productList = [];
  final _productService = ProductService();

  void setProduct(List<ProductModel> product) {
    _productList = product;
    notifyListeners();
  }

  List<ProductModel> get product => _productList;

  Future<void> fetchProductList() async {
    final item = await _productService.fetchProduct();
    setProduct(item);
    notifyListeners();
  }
}
