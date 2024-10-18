import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:takopedia/services/cart_provider.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  @override
  Widget build(BuildContext context) {
    int total = Provider.of<CartProvider>(context).totalPrice;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppBar(
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
      ),
      body: Center(
        child: QrImageView(
          data: total.toString(),
          size: 300,
          version: QrVersions.auto,
        ),
      ),
    );
  }
}
