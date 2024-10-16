// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takopedia/model/cart_model.dart';
import 'package:takopedia/pages/payment.dart';
import 'package:takopedia/services/cart_provider.dart';
import 'package:takopedia/util/style.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final _user = FirebaseAuth.instance.currentUser;
  bool isEmpty = false;
  int total = 0;
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
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;
    final total = cartProvider.totalPrice;
    // final cartItems = cartProvider.cartItems;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 247, 247),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 245, 66, 66),
        title: Center(
          child: Text(
            'Order List',
            style: TextStyle(
                color: Color.fromARGB(255, 247, 242, 242),
                fontFamily: "Poppins-bold",
                fontSize: 16),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              cartItems.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 80.0),
                            child: Text(
                              'Cart kosong, belanja dulu yuk..',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 155, 155, 155),
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 80.0, 8, 8),
                          child: ElevatedButton(
                            onPressed: () =>
                                Navigator.pushReplacementNamed(context, '/'),
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25))),
                              fixedSize: MaterialStateProperty.all(
                                  const Size(290, 52)),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 247, 108, 108)),
                              elevation: MaterialStateProperty.all(3),
                            ),
                            child: const Text(
                              'Mari...',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 246, 246),
                                  fontFamily: 'Poppins-Bold'),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            CartModel cartItem = cartItems[index];

                            return Column(
                              children: [
                                SizedBox(
                                  height: 7,
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  height: 140,
                                  width: MediaQuery.sizeOf(context).width,
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              clipBehavior: Clip.hardEdge,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(100)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        offset:
                                                            Offset(0.1, 0.1),
                                                        blurRadius: 1)
                                                  ],
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
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width -
                                                          190,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        cartItem
                                                            .product['name'],
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'Poppins-regular',
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    117,
                                                                    117,
                                                                    117)),
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
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: const Color
                                                                .fromARGB(255,
                                                                241, 241, 241)),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 11,
                                                          bottom: 8.0),
                                                  child: Container(
                                                    height: 30,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    235,
                                                                    235,
                                                                    235)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: const Color
                                                            .fromARGB(255, 247,
                                                            247, 247)),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0, right: 8),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              if (cartItem
                                                                      .quantity >
                                                                  1) {
                                                                cartProvider.min1(
                                                                    _user!.uid,
                                                                    cartItem.product[
                                                                        'id']);
                                                                if (mounted) {
                                                                  setState(
                                                                      () {});
                                                                }
                                                              } else {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          AlertDialog(
                                                                    title: Text(
                                                                        'Hapus??'),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.of(context).pop(),
                                                                        child: Text(
                                                                            'Cancel'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          cartProvider
                                                                              .remove(cartItem.id);

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
                                                            child: Container(
                                                              child: const Icon(
                                                                Icons.remove,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            '${cartItem.quantity}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              cartProvider.add1(
                                                                  _user!.uid,
                                                                  cartItem.product[
                                                                      'id']);
                                                            },
                                                            child: Container(
                                                              child: const Icon(
                                                                Icons.add,
                                                                size: 20,
                                                              ),
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
                                cartItem.id !=
                                        cartItems[cartItems.length - 1].id
                                    ? Divider(
                                        thickness: 0.2,
                                        height: 2,
                                      )
                                    : SizedBox(
                                        height: 10,
                                      )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 8.0, left: 14, bottom: 8, right: 20),
                        child: Row(
                          children: [
                            Text(
                              'Ringkasan Pembayaran',
                              style: OrderTitleTextStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 8.0, left: 14, bottom: 8, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal',
                              style: OrderDetailTextStyle,
                            ),
                            Text(
                              formatCurrency(total.toString()),
                              style: OrderDetailValueTextStyle,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 8.0, left: 14, bottom: 8, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'PPN  (10%)',
                              style: OrderDetailTextStyle,
                            ),
                            Text(
                              formatCurrency((total * 0.1).toInt().toString()),
                              style: OrderDetailValueTextStyle,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Divider(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 8.0, left: 14, bottom: 8, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: OrderTitleTextStyle,
                            ),
                            Text(
                              (formatCurrency(
                                  ((total * 0.1) + total).toInt().toString())),
                              style: TextStyle(
                                fontFamily: 'Poppins-bold',
                                fontSize: 14,
                                color: Color.fromARGB(255, 44, 44, 44),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 200,
              )
            ],
          ),
        ),
      ),
      bottomSheet: isEmpty
          ? const SizedBox()
          : BottomSheet(
              elevation: 0,
              enableDrag: false,
              backgroundColor: Color.fromARGB(139, 255, 251, 251),
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 13.0,
                    left: 8,
                    bottom: 20,
                    right: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PaymentPage())),
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          fixedSize:
                              MaterialStateProperty.all(const Size(290, 52)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 247, 108, 108)),
                          elevation: MaterialStateProperty.all(3),
                        ),
                        child: const Text(
                          'Check Out',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 246, 246),
                              fontFamily: 'Poppins-Bold'),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onClosing: () {},
            ),
    );
  }
}
