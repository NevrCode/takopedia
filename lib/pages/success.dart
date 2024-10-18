import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takopedia/pages/index.dart';
import 'package:takopedia/services/cart_provider.dart';
import 'package:takopedia/util/style.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  DateTime now = DateTime.now();
  final _user = FirebaseAuth.instance.currentUser;
  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price));
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final total = cartProvider.totalPrice;
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 251, 255, 252),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/success.gif',
                  height: 200,
                  width: 200,
                ),
                Text(
                  'Payment Successfully',
                  style: TextStyle(fontFamily: "Poppins-regular", fontSize: 26),
                ),
                Text(
                  'Thank you for purchasing<3',
                  style: TextStyle(fontFamily: "Poppins-regular", fontSize: 17),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 251, 255, 252),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 8.0, left: 14, bottom: 8, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ID Transaksi ',
                                style: OrderDetailTextStyle,
                              ),
                              Text(
                                '1558-2830-12938',
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
                                'Tanggal Transaksi',
                                style: OrderDetailTextStyle,
                              ),
                              Text(
                                formattedDate,
                                style: OrderDetailValueTextStyle,
                              ),
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
                                (formatCurrency(((total * 0.1) + total)
                                    .toInt()
                                    .toString())),
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
                  padding: const EdgeInsets.only(top: 80.0),
                  child: ElevatedButton(
                    onPressed: () {
                      cartProvider.clearCart(_user!.uid);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Index()));
                    },
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                      fixedSize: MaterialStateProperty.all(const Size(125, 52)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 25, 175, 93)),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    child: Text(
                      'Back to Menu',
                      style: TextStyle(
                          color: Color.fromARGB(255, 248, 252, 248),
                          fontFamily: 'Poppins-Bold'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
