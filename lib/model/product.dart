class Product {
  String name;
  String desc;
  int price;
  String picURL;

  Product({
    required this.name,
    required this.desc,
    required this.price,
    required this.picURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'desc': desc,
      'picURL': picURL,
    };
  }
}
