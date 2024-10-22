import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takopedia/pages/index.dart';
import 'package:takopedia/services/cart_provider.dart';
import 'package:takopedia/services/order_provider.dart';
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
    final orderProvider = Provider.of<OrderProvider>(context);
    final orderID = orderProvider.id;
    final total = cartProvider.totalPrice;
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 251, 255, 252),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: GestureDetector(
          onTap: () {
            cartProvider.clearCart(_user!.uid);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Index()));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/success.gif',
                height: 200,
                width: 200,
              ),
              const Text(
                'Payment Successfully',
                style: TextStyle(fontFamily: "Poppins-regular", fontSize: 26),
              ),
              const Text(
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
                              orderID!,
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
                padding: const EdgeInsets.only(top: 80.0),
                child: Text(
                  'tap anything to exit',
                  style: TextStyle(
                    color: Color.fromARGB(255, 212, 212, 212),
                    fontFamily: 'Poppins-regular',
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
