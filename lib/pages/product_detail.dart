import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductDetailPage extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productImage;
  final String productDescription;
  final String productId;

  ProductDetailPage({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productDescription,
    required this.productId,
  });

  Future<void> _buyProduct(BuildContext context) async {
    // Tampilkan pesan loading
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sedang memproses pembelian...'),
        duration: Duration(seconds: 2),
      ),
    );

    String cleanedPrice = productPrice.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // Fungsi untuk memformat harga dengan NumberFormat yang sesuai
  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    // Mengubah harga menjadi integer, membagi dengan 100 untuk mengurangi dua digit, lalu memformatnya
    return formatter
        .format(int.parse(price.replaceAll(RegExp(r'[^0-9]'), '')) / 100);
  }

  @override
  Widget build(BuildContext context) {
    String formattedPrice = formatCurrency(productPrice);

    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.network(
                  productImage,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.error,
                      size: 100,
                      color: Colors.red,
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                productName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              // Menampilkan harga yang sudah diformat
              Text(
                formattedPrice,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 20),
              Text(
                productDescription,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _buyProduct(context),
                child: Text('Beli Sekarang'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 36),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
