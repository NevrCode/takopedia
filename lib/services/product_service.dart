import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:takopedia/model/product_model.dart';

class ProductService {
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');
  final _storage = FirebaseStorage.instance;

  Future<void> addProduct(
      String nama, int price, String desc, String productPicPath) async {
    String picURL = await uploadPic(nama, productPicPath);
    await _products
        .add({
          'name': nama,
          'price': price,
          'description': desc,
          'product_pic': picURL,
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
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      log("Error : $e");
      return [];
    }
  }
}
