import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:takopedia/model/cart_model.dart';
import 'package:takopedia/pages/cart.dart';
import 'package:takopedia/pages/component/style.dart';

import '../model/product_model.dart';
import '../model/sales_model.dart';
import '../services/cart_service.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final nomorSepatu = [36, 37, 38, 39, 40, 41, 42, 43, 44, 45];
  final CartService _cartService = CartService();
  final User? _user = FirebaseAuth.instance.currentUser;
  int size = 40;

  // Future<void> _buyProduct(BuildContext context) async {
  //   SalesModel purchasedProduct = SalesModel(
  //     date: DateTime.timestamp().toString(),
  //     userId: _user?.uid ?? "",
  //     product: widget.product.toMap(),
  //     quantity: 1,
  //     size: size.toString(),
  //   ); // 1 karena baru bisa beli 1 di page ini
  //   // Tampilkan pesan loading
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Sedang memproses pembelian...'),
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  //   _cartService.addCart(purchasedProduct);

  //   // String cleanedPrice = productPrice.replaceAll(RegExp(r'[^0-9]'), '');
  // }

  Future<void> _addCart(BuildContext context) async {
    CartModel purchasedProduct = CartModel(
      userId: _user?.uid ?? "",
      product: widget.product.toMap(),
      quantity: 1,
      size: size.toString(),
    ); // 1 karena baru bisa beli 1 di page ini
    // Tampilkan pesan loading
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sedang memproses pembelian...'),
        duration: Duration(seconds: 2),
      ),
    );
    _cartService.addCart(
      purchasedProduct,
      _user?.uid,
      widget.product.name,
    );

    // String cleanedPrice = productPrice.replaceAll(RegExp(r'[^0-9]'), '');
  }

  void _updateSize(int e) {
    setState(() {
      size = e;
    });
  }

  // Fungsi untuk memformat harga dengan NumberFormat yang sesuai
  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    // Mengubah harga menjadi integer, membagi dengan 100 untuk mengurangi dua digit, lalu memformatnya
    return formatter.format(int.parse(price.replaceAll(RegExp(r'[^0-9]'), '')));
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the modal to expand if necessary
      builder: (BuildContext context) {
        // Use StatefulBuilder to have access to setState inside the modal
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(255, 252, 254, 255),
              ),
              height: 500, // Set a fixed height for the bottom sheet
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        const Text('Shoes Size',
                            style:
                                TextStyle(fontSize: 18, fontFamily: 'Poppins')),
                      ],
                    ),
                  ),
                  const Divider(height: 0.3),
                  Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              bottomLeft: Radius.circular(6)),
                        ),
                        height: 140,
                        width: MediaQuery.sizeOf(context).width,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        bottomLeft: Radius.circular(6)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                              offset: Offset(0.1, 0.1),
                                              blurRadius: 1)
                                        ],
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 240, 239, 239)),
                                      ),
                                      child: Image.network(
                                        widget.product.picURL,
                                        height: 120,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 3.0, top: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width -
                                                170,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.product.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  color: Color.fromARGB(
                                                      255, 117, 117, 117)),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              'Rp. 1.599.000,00',
                                              style: TextStyle(),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: const Color.fromARGB(
                                                      255, 241, 241, 241)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    top: 4),
                                                child: Text(
                                                  'Ukuran : $size',
                                                  style: TextStyle(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 0.4,
                        height: 4,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: nomorSepatu.map((e) {
                        return GestureDetector(
                          onTap: () {
                            modalSetState(() {
                              size = e;
                            });
                          },
                          child: Container(
                            width: 60,
                            height: 40,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                            decoration: BoxDecoration(
                              color: size == e
                                  ? Color.fromARGB(255, 209, 209, 209)
                                  : const Color.fromARGB(255, 235, 235, 235),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                e.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: size == e
                                      ? const Color.fromARGB(255, 73, 73, 73)
                                      : const Color.fromARGB(255, 80, 80, 80),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
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
                            onPressed: () {
                              _addCart(context);
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              side: const MaterialStatePropertyAll(BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255),
                              )),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17))),
                              fixedSize:
                                  MaterialStateProperty.all(const Size(52, 52)),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 54, 121, 199)),
                              elevation: MaterialStateProperty.all(1),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart_outlined,
                              color: Color.fromARGB(255, 250, 253, 255),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _addCart(context);
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              side: const MaterialStatePropertyAll(BorderSide(
                                  color: Color.fromARGB(255, 38, 95, 216),
                                  width: 2)),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17))),
                              fixedSize: MaterialStateProperty.all(
                                  const Size(290, 52)),
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
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedPrice = formatCurrency(
        '${widget.product.price}'); // string interpolation to cast

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
                      widget.product.picURL,
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
                          widget.product.name,
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
                          widget.product.desc,
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
                    onPressed: () => _showModalBottomSheet(context),
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
                    child: const Icon(
                      Icons.add_shopping_cart_outlined,
                      color: Color.fromARGB(255, 250, 253, 255),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _addCart(context),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
