import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductService {
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  final _storage = FirebaseStorage.instance;

  Future<void> addProduct(
      String nama, int price, String desc, String productPicPath) async {
    String picURL = await uploadPic(nama, productPicPath);
    await products
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
}
