import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:takopedia/model/product_model.dart';
import 'package:takopedia/model/sales_model.dart';
import 'package:takopedia/pages/cart.dart';
import 'package:takopedia/services/cart_service.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;
  final CartService _cartService = CartService();
  final User? _user = FirebaseAuth.instance.currentUser;

  ProductDetailPage({super.key, required this.product});

  Future<void> _buyProduct(BuildContext context) async {
    SalesModel purchasedProduct = SalesModel(
      date: DateTime.timestamp().toString(),
      userId: _user?.uid ?? "",
      product: product.toMap(),
      quantity: 1,
      size: '40',
    ); // 1 karena baru bisa beli 1 di page ini
    // Tampilkan pesan loading
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sedang memproses pembelian...'),
        duration: Duration(seconds: 2),
      ),
    );
    _cartService.addSales(purchasedProduct);

    // String cleanedPrice = productPrice.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // Fungsi untuk memformat harga dengan NumberFormat yang sesuai
  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    // Mengubah harga menjadi integer, membagi dengan 100 untuk mengurangi dua digit, lalu memformatnya
    return formatter.format(int.parse(price.replaceAll(RegExp(r'[^0-9]'), '')));
  }

  @override
  Widget build(BuildContext context) {
    String formattedPrice =
        formatCurrency('${product.price}'); // string interpolation to cast

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          'Product Detail',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartPage()));
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Image.network(
                      product.picURL,
                      width: MediaQuery.sizeOf(context).width,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          size: 100,
                          color: Colors.red,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Menampilkan harga yang sudah diformat
                        Text(
                          formattedPrice,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Color.fromARGB(255, 241, 61, 61),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          product.desc,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
              left: 16,
              right: 16,
              bottom: 10,
            ),
            child: SafeArea(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () => _buyProduct(context),
                    style: ButtonStyle(
                      side: const MaterialStatePropertyAll(BorderSide(
                        color: Color.fromARGB(255, 255, 255, 255),
                      )),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17))),
                      fixedSize: MaterialStateProperty.all(const Size(52, 52)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 54, 121, 199)),
                      elevation: MaterialStateProperty.all(1),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_shopping_cart_outlined,
                        color: Color.fromARGB(255, 250, 253, 255),
                      ),
                      onPressed: () {
                        // pe bikin cart
                      },
                    )),
                ElevatedButton(
                  onPressed: () => _buyProduct(context),
                  style: ButtonStyle(
                    side: const MaterialStatePropertyAll(BorderSide(
                        color: Color.fromARGB(255, 38, 95, 216), width: 2)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17))),
                    fixedSize: MaterialStateProperty.all(const Size(290, 52)),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 255, 255, 255)),
                    elevation: MaterialStateProperty.all(3),
                  ),
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(
                        color: Color.fromARGB(255, 38, 95, 216),
                        fontFamily: 'Poppins-Bold'),
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
