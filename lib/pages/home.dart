import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:takopedia/pages/product_detail.dart';
import 'package:takopedia/services/auth_service.dart';

import '../model/product_model.dart';
import '../services/cart_service.dart';
import '../services/product_service.dart';
import 'component/style.dart';

final List<String> imgList = [
  'assets/img/dunkbrown.jpg',
  'assets/img/excee-carousel.jpg',
  'assets/img/ultraboost.jpg',
  'assets/img/max99.jpg',
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _user = FirebaseAuth.instance.currentUser;
  final _productService = ProductService();
  final _cart = CartService();
  final _auth = AuthService();
  late Future<List<ProductModel>> _productList;
  int cartItem = 0;
  bool isLoading = true;

  final List<Widget> carouselItem = imgList
      .map((item) => Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.asset(item, fit: BoxFit.cover, width: 1000.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                ],
              ),
            ),
          ))
      .toList();

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
    return SafeArea(
      child: Container(
        color: const Color.fromARGB(255, 255, 251, 251),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 60,
                            width: 170,
                            child: Card(
                              color: Color.fromARGB(255, 238, 250, 238),
                              elevation: 0.2,
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                size: 23,
                                color: Color.fromARGB(255, 77, 192, 81),
                              ),
                            ),
                          ),
                          Text(
                            "Style",
                            style: drawerTextStyle,
                          )
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 60,
                            width: 170,
                            child: Card(
                              color: Color.fromARGB(255, 245, 238, 250),
                              elevation: 0.2,
                              child: Icon(
                                Icons.fitness_center_outlined,
                                size: 23,
                                color: Color.fromARGB(255, 161, 82, 236),
                              ),
                            ),
                          ),
                          Text(
                            "Gym",
                            style: drawerTextStyle,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
