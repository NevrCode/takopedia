import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takopedia/model/product_model.dart';
import 'package:takopedia/model/user_model.dart';
import 'package:takopedia/pages/add_product.dart';
import 'package:takopedia/pages/login.dart';
import 'package:takopedia/pages/product_detail.dart';
import 'package:takopedia/services/auth_service.dart';
import 'package:takopedia/services/product_service.dart';
import 'package:takopedia/services/user_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _auth = AuthService();
  final _user = FirebaseAuth.instance.currentUser;
  final _productService = ProductService();
  late Future<List<ProductModel>> _productList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _productList = _productService.fetchProduct();
  }

  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price));
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Takopedia',
          style: TextStyle(fontFamily: 'Poppins-Regular'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userProvider?.nama ?? 'Quest'), // Nama pengguna
              accountEmail:
                  Text(_user?.email ?? "name@domain.com"), // Email pengguna
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  userProvider?.img ??
                      'https://firebasestorage.googleapis.com/v0/b/takopedia-24e8b.appspot.com/o/profile_pic%2FJvtcPsGmaTUi0kUtPdTdGo7QU443?alt=media&token=a97b2473-bc5f-4ebe-85aa-5fb7ee46d391', // Ganti dengan URL foto pengguna
                ),
              ),
              decoration: const BoxDecoration(),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Keranjang Belanja'),
              onTap: () {
                // Tambahkan logika untuk navigasi ke halaman keranjang belanja
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Riwayat Belanja'),
              onTap: () {
                // Tambahkan logika untuk navigasi ke halaman riwayat belanja
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting'),
              onTap: () {
                // Tambahkan logika untuk navigasi ke halaman pengaturan
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Halaman Login'),
              onTap: () {
                // Navigasi ke halaman login
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Tambahkan logika untuk logout
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: FutureBuilder(
                    future: _productList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                'Error: ${snapshot.error}')); // Show error if fetching failed
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text(
                                'Product Kosong')); // Show error if fetching failed
                      } else {
                        List<ProductModel> products = snapshot.data!;

                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            ProductModel product = products[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetailPage(
                                              product: product,
                                            )));
                              },
                              child: Card(
                                elevation: 0.4,
                                child: Container(
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Display item image
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
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
                                        child: Text(
                                          product.name, // Display item title
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
