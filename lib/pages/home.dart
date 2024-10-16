import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takopedia/pages/product_detail.dart';
import 'package:takopedia/services/product_provider.dart';

import '../services/user_provider.dart';
import '../util/style.dart';

final List<String> imgList = [
  'assets/img/caro1.jpg',
  'assets/img/caro2.jpg',
  'assets/img/caro3.jpg',
  'assets/img/caro4.jpg',
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int cartItem = 0;
  bool isLoading = true;
  bool isTakeAway = false;

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
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserProvider>();
    var products = Provider.of<ProductProvider>(context).product;
    return Container(
      decoration: const BoxDecoration(color: ContentMainBg),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              CarouselSlider(
                items: carouselItem,
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 1.5 / 1,
                  viewportFraction: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 220,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: Container(
                        width: 336,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromARGB(255, 199, 199, 199),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'Hi, ${userProvider.user!.nama}',
                                  style: const TextStyle(
                                      fontFamily: 'Poppins-bold', fontSize: 18),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 16.0),
                                child: Icon(
                                  Icons.person,
                                  color: Color.fromARGB(255, 34, 34, 34),
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 70,
                              width: 360,
                              child: Text(
                                "Selamat datang, mari kita mulai dengan cinta",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Poppins-bold',
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 255, 100, 100),
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        )),
                    products.isEmpty
                        ? const Center(child: Text('No products available'))
                        : GroupedListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            floatingHeader: true,
                            useStickyGroupSeparators: true,
                            elements: products,
                            groupBy: (e) => e.type,
                            footer: const Padding(
                              padding: EdgeInsets.fromLTRB(8.0, 16, 8, 8),
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
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    val,
                                    style: const TextStyle(
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
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 114, 114, 114)),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
