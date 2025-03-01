import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:takopedia/pages/success.dart';
import 'package:takopedia/services/cart_provider.dart';
import 'package:takopedia/services/order_provider.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 245, 66, 66),
        title: Center(
          child: Text(
            'Payment QR',
            style: TextStyle(
                color: Color.fromARGB(255, 247, 242, 242),
                fontFamily: "Poppins-bold",
                fontSize: 16),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: Color.fromARGB(255, 211, 210, 210))),
              child: QrImageView(
                data: "Thanks",
                size: 300,
                version: QrVersions.auto,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
              left: 16,
              right: 16,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SuccessPage())),
                  style: ButtonStyle(
                    surfaceTintColor:
                        const MaterialStatePropertyAll(Colors.white),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                    fixedSize: MaterialStateProperty.all(const Size(290, 52)),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 235, 90, 90)),
                    elevation: MaterialStateProperty.all(3),
                  ),
                  child: Text(
                    'Sudah bayar',
                    style: TextStyle(
                        color: Color.fromARGB(255, 245, 239, 239),
                        fontFamily: 'Poppins-Bold'),
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
