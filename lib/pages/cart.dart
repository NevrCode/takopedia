import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:takopedia/model/cart_model.dart';
import 'package:takopedia/model/sales_model.dart';
import 'package:takopedia/services/cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cardService = CartService();
  final _user = FirebaseAuth.instance.currentUser;

  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 246, 249, 255)),
          child: FutureBuilder(
            future: _cardService.fetchSales(_user!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                        'Error: ${snapshot.error}')); // Show error if fetching failed
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('cart Kosong'),
                ); // Show error if fetching failed
              } else {
                List<CartModel> cartItems = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      CartModel cartItem = cartItems[index];
                      int quantity = 1;
                      return Column(
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
                                            boxShadow: [
                                              const BoxShadow(
                                                  offset: Offset(0.1, 0.1),
                                                  blurRadius: 1)
                                            ],
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 240, 239, 239)),
                                          ),
                                          child: Image.network(
                                            cartItem.product['picURL'],
                                            height: 120,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3.0, top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width -
                                                170,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  cartItem.product['name'],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      color: Color.fromARGB(
                                                          255, 117, 117, 117)),
                                                ),
                                                Text(
                                                  formatCurrency(cartItem
                                                      .product['price']
                                                      .toString()),
                                                  style: TextStyle(),
                                                ),
                                                Container(
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              241,
                                                              241,
                                                              241)),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0,
                                                        right: 8.0,
                                                        top: 4),
                                                    child: Text(
                                                      'Ukuran : ${cartItem.size}',
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
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Container(
                                              height: 30,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              158,
                                                              158,
                                                              158)),
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  color: const Color.fromARGB(
                                                      255, 247, 247, 247)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8.0, right: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (quantity > 1) {
                                                          setState(() {
                                                            quantity--;
                                                          });
                                                        } else {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                              title: Text(
                                                                  'Hapus??'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
                                                                  child: Text(
                                                                      'Cancel'),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    await _cardService
                                                                        .deleteProductFromCart(
                                                                      _user.uid,
                                                                      cartItem.product[
                                                                          'name'],
                                                                    );
                                                                    setState(
                                                                        () {}); //  buat refresh cart nya (jangan di apus ya anjeng)

                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      'sure'),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: const Text(
                                                        '-',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                    Text(
                                                      '$quantity',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          quantity++;
                                                        });
                                                      },
                                                      child: const Text(
                                                        '+',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    51,
                                                                    51,
                                                                    51)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
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
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
