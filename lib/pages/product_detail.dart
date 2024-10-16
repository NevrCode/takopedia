import 'dart:developer';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takopedia/model/cart_model.dart';
import 'package:takopedia/pages/cart.dart';
import 'package:badges/badges.dart' as badges;
import 'package:takopedia/services/cart_provider.dart';

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
  final CartService _cartService = CartService();
  final User? _user = FirebaseAuth.instance.currentUser;
  int cartItem = 0;
  int value = 0;
  bool loading = false;
  int? nullableValue;
  bool size = false;
  bool ice = true;
  bool sugar = true;

  Future<void> _addCart(BuildContext context) async {
    final productMap = widget.product.toMap();
    CartModel purchasedProduct = CartModel(
      id: productMap['id'] + _user!.uid,
      userId: _user.uid,
      product: productMap,
      quantity: 1,
      size: size ? 'Regular' : 'Large',
      ice: ice ? 'Normal' : 'Less',
      sugar: sugar ? 'Normal' : 'Less',
    ); // 1 karena baru bisa beli 1 di page ini
    // Tampilkan pesan loading
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sedang memproses pembelian...'),
        duration: Duration(seconds: 2),
      ),
    );
    Provider.of<CartProvider>(context, listen: false)
        .addItemToCart(purchasedProduct);

    // String cleanedPrice = productPrice.replaceAll(RegExp(r'[^0-9]'), '');
  }

  @override
  void initState() {
    super.initState();
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
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Use StatefulBuilder to have access to setState inside the modal
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(255, 252, 254, 255),
              ),
              height: 700, // Set a fixed height for the bottom sheet
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
                        const Text(
                          'Shoes Size',
                          style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                        ),
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
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  color: Color.fromARGB(
                                                      255, 117, 117, 117)),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              formatCurrency(widget
                                                  .product.price
                                                  .toString()),
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
                      const Divider(
                        thickness: 0.4,
                        height: 4,
                      ),
                    ],
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
        title: Center(
          child: const Text(
            'Product Detail',
            style: TextStyle(
                color: Color.fromARGB(255, 37, 37, 37),
                fontFamily: 'Poppins-bold',
                fontSize: 16),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('carts')
                  .where('uid', isEqualTo: _user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Color.fromARGB(255, 77, 77, 77),
                      size: 25,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return badges.Badge(
                    badgeContent: const Text(
                      '-',
                      style: TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Color.fromARGB(255, 77, 77, 77),
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartPage()));
                      },
                    ),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Color.fromARGB(255, 77, 77, 77),
                      size: 25,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CartPage()));
                    },
                  );
                } else {
                  int itemCount = snapshot.data!.docs.length;
                  return badges.Badge(
                    position: badges.BadgePosition.topEnd(top: 0, end: 5),
                    badgeContent: Text(
                      '$itemCount',
                      style: TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Color.fromARGB(255, 77, 77, 77),
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CartPage()));
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10, 10, 20.0),
                    child: AnimatedToggleSwitch<bool>.size(
                      current: size,
                      values: const [true, false],
                      iconOpacity: 0.2,
                      indicatorSize: Size.fromWidth(
                          MediaQuery.sizeOf(context).width - 220),
                      customIconBuilder: (context, local, global) => Text(
                          local.value ? 'Regular' : 'Large',
                          style: TextStyle(
                              fontFamily: "Poppins-regular",
                              color: Color.lerp(Colors.black, Colors.white,
                                  local.animationValue))),
                      borderWidth: 4.0,
                      iconAnimationType: AnimationType.onHover,
                      style: ToggleStyle(
                        indicatorColor: Color.fromARGB(255, 255, 87, 87),
                        borderColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1.5),
                          ),
                        ],
                      ),
                      selectedIconScale: 1.0,
                      onChanged: (b) => setState(() => size = b),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10, 10, 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 1.0),
                              child: Text(
                                'Ice',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 155, 155, 155),
                                    fontFamily: 'Poppins-regular',
                                    fontSize: 20),
                              ),
                            ),
                            AnimatedToggleSwitch<bool>.size(
                              current: ice,
                              values: const [false, true],
                              iconOpacity: 0.2,
                              indicatorSize: Size.fromWidth(70),
                              customIconBuilder: (context, local, global) =>
                                  Text(local.value ? 'Normal' : 'Less',
                                      style: TextStyle(
                                          fontFamily: "Poppins-regular",
                                          color: Color.lerp(
                                              Colors.black,
                                              Colors.white,
                                              local.animationValue))),
                              borderWidth: 4.0,
                              iconAnimationType: AnimationType.onHover,
                              style: ToggleStyle(
                                indicatorColor:
                                    Color.fromARGB(255, 255, 87, 87),
                                borderColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  const BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 1.5),
                                  ),
                                ],
                              ),
                              selectedIconScale: 1.0,
                              onChanged: (b) => setState(() => ice = b),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 1.0),
                                child: Text(
                                  'Sugar',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 155, 155, 155),
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: AnimatedToggleSwitch<bool>.size(
                                  current: sugar,
                                  values: const [false, true],
                                  iconOpacity: 0.2,
                                  indicatorSize: Size.fromWidth(70),
                                  customIconBuilder: (context, local, global) =>
                                      Text(local.value ? 'Normal' : 'Less',
                                          style: TextStyle(
                                              fontFamily: "Poppins-regular",
                                              color: Color.lerp(
                                                  Colors.black,
                                                  Colors.white,
                                                  local.animationValue))),
                                  borderWidth: 4.0,
                                  iconAnimationType: AnimationType.onHover,
                                  style: ToggleStyle(
                                    indicatorColor:
                                        Color.fromARGB(255, 255, 87, 87),
                                    borderColor: Colors.transparent,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      const BoxShadow(
                                        color: Colors.black26,
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0, 1.5),
                                      ),
                                    ],
                                  ),
                                  selectedIconScale: 1.0,
                                  onChanged: (b) => setState(() => sugar = b),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                        Color.fromARGB(255, 247, 78, 78)),
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
                        color: Color.fromARGB(255, 253, 93, 93), width: 2)),
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
                        color: Color.fromARGB(255, 247, 90, 90),
                        fontFamily: 'Poppins-Bold'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color colorBuilder(int value) => switch (value) {
        0 => Colors.blueAccent,
        1 => Colors.green,
        2 => Colors.orangeAccent,
        _ => Colors.red,
      };
}
