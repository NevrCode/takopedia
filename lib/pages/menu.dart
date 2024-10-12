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
  final _user = FirebaseAuth.instance.currentUser;
  final _productService = ProductService();
  final _product = FirebaseFirestore.instance.collection('products');
  late Future<List<ProductModel>> _productList;
  int cartItem = 0;

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
                AnimatedToggleSwitch<int>.size(
                  current: min(value, 2),
                  style: ToggleStyle(
                    backgroundColor: Color.fromARGB(8, 255, 255, 255),
                    indicatorColor: const Color(0xFFEC3345),
                    borderColor: Color.fromARGB(248, 199, 199, 199),
                    borderRadius: BorderRadius.circular(15.0),
                    indicatorBorderRadius: BorderRadius.zero,
                  ),
                  values: const [0, 1],
                  iconOpacity: 1.0,
                  selectedIconScale: 1.0,
                  indicatorSize: const Size.fromWidth(165),
                  iconAnimationType: AnimationType.onHover,
                  styleAnimationType: AnimationType.onHover,
                  spacing: 2.0,
                  height: 40,
                  customSeparatorBuilder: (context, local, global) {
                    final opacity =
                        ((global.position - local.position).abs() - 0.5)
                            .clamp(0.0, 1.0);
                    return VerticalDivider(
                        indent: 10.0,
                        endIndent: 10.0,
                        color: Colors.white38.withOpacity(opacity));
                  },
                  customIconBuilder: (context, local, global) {
                    final text = const ['Take Away', 'Delivery'][local.index];
                    final icon = const [
                      Icons.directions_walk,
                      Icons.local_shipping_rounded
                    ][local.index];
                    return Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(text,
                            style: TextStyle(
                                color: Color.lerp(Colors.black, Colors.white,
                                    local.animationValue),
                                fontFamily: 'Poppins-regular')),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          icon,
                          color: Color.lerp(
                              Colors.black, Colors.white, local.animationValue),
                        ),
                      ],
                    ));
                  },
                  borderWidth: 0.4,
                  onChanged: (i) => setState(() => value = i),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                                padding: const EdgeInsets.only(left: 8.0),
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
                Text(
                  'Deals 10.10',
                  style: TextStyle(fontFamily: 'Poppins-regular', fontSize: 20),
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
                              child: Text(
                                'Sampai Sini Saja Kenangan Kita ...',
                                style: TextStyle(
                                    fontFamily: 'Poppins-Bold',
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 207, 104, 104)),
                              ),
                            ),
                            groupSeparatorBuilder: (String val) => Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(val),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                SizedBox(
                                                  height: 10,
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
