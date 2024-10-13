import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:takopedia/pages/product_detail.dart';
import 'package:takopedia/services/auth_service.dart';

import '../model/product_model.dart';
import '../services/cart_service.dart';
import '../services/product_service.dart';
import 'component/style.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final _locationContrller = TextEditingController();
  final _user = FirebaseAuth.instance.currentUser;
  final _productService = ProductService();
  final _product = FirebaseFirestore.instance.collection('products');
  late Future<List<ProductModel>> _productList;
  int cartItem = 0;
  bool isTakeAway = false;
  int value = 0;
  bool isLoading = true;

  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price));
  }

  @override
  void initState() {
    super.initState();
    _productList = _productService.fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 255, 251, 251)),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                AnimatedToggleSwitch<bool>.size(
                  current: isTakeAway,
                  values: const [true, false],
                  iconOpacity: 0.2,
                  indicatorSize: const Size.fromWidth(170),
                  customIconBuilder: (context, local, global) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(local.value ? 'Take Away' : 'Delivery',
                          style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: Color.lerp(Colors.black, Colors.white,
                                  local.animationValue))),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        local.value
                            ? Icons.directions_walk
                            : Icons.local_shipping_rounded,
                        color: Color.lerp(
                            Colors.black, Colors.white, local.animationValue),
                      ),
                    ],
                  ),
                  borderWidth: 4.0,
                  iconAnimationType: AnimationType.onHover,
                  style: ToggleStyle(
                    indicatorColor: Color.fromARGB(255, 252, 79, 79),
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
                  onChanged: (b) => setState(() => isTakeAway = b),
                ),
                SizedBox(
                  height: 10,
                ),
                isTakeAway
                    ? SizedBox(
                        height: 10,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          width: 336,
                          height: 40,
                          child: TextField(
                            controller: _locationContrller,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.location_pin),
                                contentPadding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.8),
                                hintText: 'Location',
                                hintStyle: TextStyle(
                                    fontFamily: 'Poppins-Bold', fontSize: 14),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 179, 178, 178)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 136, 136, 136),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: const Color.fromARGB(
                                        255, 185, 185, 185),
                                  ),
                                )),
                          ),
                        ),
                      ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Container(
                    width: 336,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color.fromARGB(255, 199, 199, 199),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Row(
                            children: [
                              Icon(Icons.store),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'GLORIA',
                                  style: TextStyle(fontFamily: 'Poppins-bold'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            'Ubah',
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 151, 151, 151)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FutureBuilder(
                  future: _productList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              'Error: ${snapshot.error}')); // Show error if fetching failed
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text(
                              'Product Kosong')); // Show error if fetching failed
                    } else {
                      List<ProductModel> products = snapshot.data!;

                      return CustomScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        slivers: [
                          SliverGroupedListView(
                            // physics: const NeverScrollableScrollPhysics(),
                            // shrinkWrap: true,
                            // floatingHeader: true,
                            // useStickyGroupSeparators: true,
                            elements: products,
                            groupBy: (e) => e.type,
                            footer: Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 16, 8, 8),
                              child: Center(
                                child: Text(
                                  'Sampai sini aja...',
                                  style: TextStyle(
                                      fontFamily: 'Poppins-Bold',
                                      fontSize: 17,
                                      color:
                                          Color.fromARGB(255, 207, 104, 104)),
                                ),
                              ),
                            ),
                            groupSeparatorBuilder: (String val) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    val,
                                    style: TextStyle(
                                        fontFamily: 'Poppins-regular',
                                        fontSize: 22),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Divider(
                                    indent: 10,
                                    endIndent:
                                        MediaQuery.sizeOf(context).width - 70,
                                  ),
                                ),
                              ],
                            ),
                            itemBuilder: (context, dynamic product) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailPage(
                                                  product: product)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Card(
                                    elevation: 0.3,
                                    child: Container(
                                      height: 100,
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Display item image
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10)),
                                            child: AspectRatio(
                                              aspectRatio: 1,
                                              child: Image.network(
                                                product.picURL,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                // Adjust the height as needed
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.name,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        'Poppins-regular',
                                                  ),
                                                ),
                                                Text(
                                                  formatCurrency(
                                                      product.price.toString()),
                                                  style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              114,
                                                              114,
                                                              114)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
