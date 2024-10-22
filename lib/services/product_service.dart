import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:takopedia/model/product_model.dart';

class ProductService {
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');
  final _storage = FirebaseStorage.instance;

  Future<void> addProduct(String nama, int price, String desc,
      String productPicPath, String type, int rate) async {
    String picURL = await uploadPic(nama, productPicPath);
    await _products
        .add({
          'name': nama,
          'price': price,
          'description': desc,
          'product_pic': picURL,
          'type': type,
          'rate': rate
        })
        .then((value) => log("Product Added"))
        .catchError((error) => log("Failed to add product: $error"));
  }

  Future<String> uploadPic(String name, String filePath) async {
    try {
      Reference storageRef = _storage.ref().child('productPic/$name');
      UploadTask uploadTask = storageRef.putFile(File(filePath));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      log("Error : ${e.toString()}");
      rethrow;
    }
  }

  Future<List<ProductModel>> fetchProduct() async {
    try {
      QuerySnapshot snapshot = await _products.get();
      return snapshot.docs.map((doc) {
        return ProductModel.fromDocument(doc);
      }).toList();
    } catch (e) {
      print("Error : $e");
      return [];
    }
  }

  Future<double> updateRate(ProductModel product, int rate) async {
    int pr = product.rater + 1;
    double newrate = ((product.rate * product.rater) + rate) / pr;
    print("product rate : " + product.rate.toString());
    print("rater o : " + product.rater.toString());
    print("rate : " + newrate.toString());
    print("rater : " + pr.toString());
    await _products.doc(product.id).update({
      'rater': pr,
      'rate': newrate,
    });
    return newrate;
  }
}
