import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takopedia/model/cart_model.dart';
import 'package:takopedia/pages/cart.dart';
import 'package:badges/badges.dart' as badges;
import 'package:takopedia/services/cart_provider.dart';

import '../model/product_model.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
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
    );
    Fluttertoast.showToast(
      toastLength: Toast.LENGTH_LONG,
      msg: 'Minuman Berhasil Ditambahkan !',
      backgroundColor: Color.fromARGB(255, 101, 185, 80),
      textColor: Color.fromARGB(255, 252, 251, 251),
      fontSize: 16,
      gravity: ToastGravity.BOTTOM,
    );

    Provider.of<CartProvider>(context, listen: false)
        .addItemToCart(purchasedProduct);
  }

  @override
  void initState() {
    super.initState();
  }

  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price.replaceAll(RegExp(r'[^0-9]'), '')));
  }

  @override
  Widget build(BuildContext context) {
    String formattedPrice = formatCurrency('${widget.product.price}');

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
          ),
        ),
        surfaceTintColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'Product Detail',
          style: TextStyle(
              color: Color.fromARGB(255, 37, 37, 37),
              fontFamily: 'Poppins-bold',
              fontSize: 16),
        ),
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
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 30,
                                color: Color.fromARGB(255, 253, 235, 72),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '${widget.product.rate} /5',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 114, 114, 114),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          widget.product.desc,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          widget.product.rater.toString(),
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
                        backgroundColor: Color.fromARGB(255, 253, 253, 253),
                        indicatorColor: const Color.fromARGB(255, 255, 87, 87),
                        borderColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(12.0),
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
                            const Padding(
                              padding: EdgeInsets.only(left: 1.0),
                              child: Text(
                                'Ice',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 155, 155, 155),
                                    fontFamily: 'Poppins-regular',
                                    fontSize: 16),
                              ),
                            ),
                            AnimatedToggleSwitch<bool>.size(
                              current: ice,
                              values: const [false, true],
                              iconOpacity: 0.2,
                              indicatorSize: const Size.fromWidth(70),
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
                                backgroundColor:
                                    Color.fromARGB(255, 253, 253, 253),
                                indicatorColor:
                                    const Color.fromARGB(255, 255, 87, 87),
                                borderColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(12.0),
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
                              const Padding(
                                padding: EdgeInsets.only(left: 1.0),
                                child: Text(
                                  'Sugar',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 155, 155, 155),
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: AnimatedToggleSwitch<bool>.size(
                                  current: sugar,
                                  values: const [false, true],
                                  iconOpacity: 0.2,
                                  indicatorSize: const Size.fromWidth(70),
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
                                    backgroundColor:
                                        Color.fromARGB(255, 253, 253, 253),
                                    indicatorColor:
                                        const Color.fromARGB(255, 255, 87, 87),
                                    borderColor: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12.0),
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
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      left: 16,
                      right: 16,
                      bottom: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _addCart(context),
                          style: ButtonStyle(
                            surfaceTintColor:
                                const MaterialStatePropertyAll(Colors.white),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            fixedSize:
                                MaterialStateProperty.all(const Size(290, 52)),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 235, 90, 90)),
                            elevation: MaterialStateProperty.all(3),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.add_shopping_cart,
                                  color: Color.fromARGB(255, 252, 247, 247),
                                ),
                              ),
                              Text(
                                'Tambah Ke Keranjang',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 245, 239, 239),
                                    fontFamily: 'Poppins-Bold'),
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
        ],
      ),
    );
  }

  Color colorBuilder(int value) => switch (value) {
        _ => Colors.red,
      };
}
