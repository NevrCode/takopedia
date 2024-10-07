class ProductModel {
  String name;
  String desc;
  int price;
  String picURL;

  ProductModel({
    required this.name,
    required this.desc,
    required this.price,
    required this.picURL,
  });

  factory ProductModel.fromMap(Map<String, dynamic> data) {
    return ProductModel(
      name: data['name'] ?? '',
      desc: data['description'] ?? '',
      price: data['price'] ?? '',
      picURL: data['product_pic'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'desc': desc,
      'picURL': picURL,
    };
  }
}
