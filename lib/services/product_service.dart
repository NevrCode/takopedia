import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:takopedia/model/product.dart';

class ProductService {
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  final _storage = FirebaseStorage.instance;

  Future<void> addProduct(Map<String, dynamic> product) async {
    products
        .add({product})
        .then((value) => log("User Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }

  Future<String> uploadPic(String productId, String filePath) async {
    try {
      Reference storageRef = _storage.ref().child('productPic/$productId');
      UploadTask uploadTask = storageRef.putFile(File(filePath));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
