// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takopedia/model/cart_model.dart';
import 'package:takopedia/pages/component/costum_radio_item.dart';
import 'package:takopedia/pages/home.dart';
import 'package:takopedia/pages/index.dart';
import 'package:takopedia/pages/payment.dart';
import 'package:takopedia/pages/qr_generate.dart';
import 'package:takopedia/pages/success.dart';
import 'package:takopedia/services/cart_provider.dart';
import 'package:takopedia/util/style.dart';

enum Payment { card, qris }

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _cartNumController = TextEditingController();
  final _cartValidMonth = TextEditingController();
  final _cartValidYear = TextEditingController();
  Payment? _paymentMethod = Payment.qris;
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
            'Payment',
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
                      padding: const EdgeInsets.all(10.0),
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
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        bottomLeft: Radius.circular(6)),
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
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(6),
                                                      bottomLeft:
                                                          Radius.circular(6)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        offset:
                                                            Offset(0.1, 0.1),
                                                        blurRadius: 1)
                                                  ],
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              240,
                                                              239,
                                                              239)),
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
                                                          170,
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
                                                          bottom: 8.0,
                                                          right: 20),
                                                  child: Text(
                                                    '${cartItem.quantity}x',
                                                    style: OrderTitleTextStyle,
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
                padding: const EdgeInsets.all(10.0),
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
              Padding(
                padding: const EdgeInsets.all(10.0),
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
                              'Payment with',
                              style: OrderTitleTextStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 8.0, left: 7, bottom: 8, right: 2),
                        child: Column(
                          children: [
                            _buildRadioTile(
                                "Card", Payment.card, Icons.credit_card),
                            _buildRadioTile(
                                "Qris", Payment.qris, Icons.qr_code_2),
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
                        onPressed: () {
                          if (_paymentMethod == Payment.card) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SuccessPage()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const QrPage()));
                          }
                        },
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
                        child: Text(
                          'Pay ${formatCurrency(((total * 0.1) + total).toInt().toString())}',
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

  Widget _buildRadioTile(String title, Payment value, IconData icon) {
    return ListTile(
      leading: SizedBox(
        // height: 40,
        width: 310,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(fontFamily: 'Poppins-bold', fontSize: 15),
                  ),
                ),
              ],
            ),
            Radio<Payment>(
              value: value,
              groupValue: _paymentMethod,
              onChanged: (Payment? newValue) {
                setState(() {
                  _paymentMethod = newValue;
                });
              },
            ),
          ],
        ),
      ),
      onTap: () {
        if (title == 'Card') {
          ShowCardPayment();
        }
        setState(() {
          _paymentMethod = value;
        });
      },
    );
  }

  // ignore: non_constant_identifier_names
  void ShowCardPayment() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(255, 252, 254, 255),
              ),
              height: 360,
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
                          'Credit Card',
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
                        width: MediaQuery.sizeOf(context).width,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width - 60,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: SizedBox(
                                            width: 430,
                                            height: 40,
                                            child: TextField(
                                              style: TextStyle(
                                                  fontFamily:
                                                      'Poppins-regular'),
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: _cartNumController,
                                              decoration: InputDecoration(
                                                  prefixIcon:
                                                      const Icon(Icons.numbers),
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          0, 8, 8, 8),
                                                  filled: true,
                                                  fillColor: Colors.white
                                                      .withOpacity(0.8),
                                                  hintText: 'Card Number',
                                                  hintStyle: TextStyle(
                                                      fontFamily:
                                                          'Poppins-Bold',
                                                      fontSize: 14),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 179, 178, 178),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 136, 136, 136),
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide: BorderSide(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              185,
                                                              185,
                                                              185),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, top: 8.0),
                                          child: Text(
                                            'Valid thru : ',
                                            style: TextStyle(
                                                fontFamily: 'Poppins-bold',
                                                fontSize: 14,
                                                color: const Color.fromARGB(
                                                    255, 131, 131, 131)),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: SizedBox(
                                                width: 60,
                                                height: 40,
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: _cartValidMonth,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              8, 8, 8, 8),
                                                      filled: true,
                                                      fillColor: Colors.white
                                                          .withOpacity(0.8),
                                                      hintText: '',
                                                      hintStyle: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Bold',
                                                          fontSize: 14),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    179,
                                                                    178,
                                                                    178)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              255,
                                                              136,
                                                              136,
                                                              136),
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        borderSide: BorderSide(
                                                          color: const Color
                                                              .fromARGB(255,
                                                              185, 185, 185),
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, top: 8.0),
                                              child: Text(
                                                '/',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-regular',
                                                    fontSize: 20,
                                                    color: const Color.fromARGB(
                                                        255, 131, 131, 131)),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, left: 6),
                                              child: SizedBox(
                                                width: 60,
                                                height: 40,
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: _cartValidYear,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              8, 8, 8, 8),
                                                      filled: true,
                                                      fillColor: Colors.white
                                                          .withOpacity(0.8),
                                                      hintText: '',
                                                      hintStyle: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Bold',
                                                          fontSize: 14),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    179,
                                                                    178,
                                                                    178)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              255,
                                                              136,
                                                              136,
                                                              136),
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        borderSide: BorderSide(
                                                          color: const Color
                                                              .fromARGB(255,
                                                              185, 185, 185),
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: ButtonStyle(
                                                  side:
                                                      const MaterialStatePropertyAll(
                                                          BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              width: 2)),
                                                  shape:
                                                      MaterialStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          17))),
                                                  fixedSize:
                                                      MaterialStateProperty.all(
                                                          const Size(130, 52)),
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              0, 0, 0, 0)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color.fromARGB(255,
                                                              252, 113, 113)),
                                                  elevation:
                                                      MaterialStateProperty.all(
                                                          2),
                                                ),
                                                child: const Text(
                                                  'use card',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      fontFamily:
                                                          'Poppins-Bold'),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
