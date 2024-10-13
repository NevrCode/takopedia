import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  String name;
  String desc;
  int price;
  String picURL;
  String type;

  ProductModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.picURL,
    required this.type,
  });

  factory ProductModel.fromDocument(DocumentSnapshot doc) {
    return ProductModel(
      id: doc.id,
      name: doc['name'] ?? '',
      desc: doc['description'] ?? '',
      price: doc['price'] ?? '',
      picURL: doc['product_pic'] ?? '',
      type: doc['type'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'desc': desc,
      'picURL': picURL,
      'type': type,
    };
  }
}
