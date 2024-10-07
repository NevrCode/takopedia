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
  final _user = FirebaseAuth.instance.currentUser;
  final _productService = ProductService();
  late Future<List<ProductModel>> _productList;
  bool isLoading = true;
  final walkinSVG =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512"><path d="M160 48a48 48 0 1 1 96 0 48 48 0 1 1 -96 0zM126.5 199.3c-1 .4-1.9 .8-2.9 1.2l-8 3.5c-16.4 7.3-29 21.2-34.7 38.2l-2.6 7.8c-5.6 16.8-23.7 25.8-40.5 20.2s-25.8-23.7-20.2-40.5l2.6-7.8c11.4-34.1 36.6-61.9 69.4-76.5l8-3.5c20.8-9.2 43.3-14 66.1-14c44.6 0 84.8 26.8 101.9 67.9L281 232.7l21.4 10.7c15.8 7.9 22.2 27.1 14.3 42.9s-27.1 22.2-42.9 14.3L247 287.3c-10.3-5.2-18.4-13.8-22.8-24.5l-9.6-23-19.3 65.5 49.5 54c5.4 5.9 9.2 13 11.2 20.8l23 92.1c4.3 17.1-6.1 34.5-23.3 38.8s-34.5-6.1-38.8-23.3l-22-88.1-70.7-77.1c-14.8-16.1-20.3-38.6-14.7-59.7l16.9-63.5zM68.7 398l25-62.4c2.1 3 4.5 5.8 7 8.6l40.7 44.4-14.5 36.2c-2.4 6-6 11.5-10.6 16.1L54.6 502.6c-12.5 12.5-32.8 12.5-45.3 0s-12.5-32.8 0-45.3L68.7 398z"/></svg>';

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
        backgroundColor: Color.fromARGB(255, 61, 118, 172),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Calceus',
          style: TextStyle(fontFamily: 'Poppins-Regular', color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawerScrimColor: const Color.fromARGB(117, 78, 78, 78),
      drawer: Drawer(
        backgroundColor: Colors.white,
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
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 50, 123, 187),
              ),
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
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 246, 249, 252)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: Card(
                                color: Color.fromARGB(255, 238, 250, 238),
                                elevation: 0.2,
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 23,
                                  color: Color.fromARGB(255, 77, 192, 81),
                                ),
                              ),
                            ),
                            Text("Style")
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: Card(
                                color: Color.fromARGB(255, 250, 238, 238),
                                elevation: 0.2,
                                child: Icon(
                                  Icons.fastfood_outlined,
                                  size: 23,
                                  color: Color.fromARGB(255, 192, 77, 77),
                                ),
                              ),
                            ),
                            Text("Run")
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: Card(
                                color: Color.fromARGB(255, 238, 246, 250),
                                elevation: 0.2,
                                child: Icon(
                                  Icons.ac_unit_rounded,
                                  size: 23,
                                  color: Color.fromARGB(255, 77, 136, 192),
                                ),
                              ),
                            ),
                            Text(
                              "Walk",
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: Card(
                                color: Color.fromARGB(255, 250, 250, 238),
                                elevation: 0.2,
                                child: Icon(
                                  Icons.wb_sunny_outlined,
                                  size: 23,
                                  color: Color.fromARGB(255, 236, 226, 82),
                                ),
                              ),
                            ),
                            Text("Trail")
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: Card(
                                color: Color.fromARGB(255, 245, 238, 250),
                                elevation: 0.2,
                                child: Icon(
                                  Icons.fitness_center_outlined,
                                  size: 23,
                                  color: Color.fromARGB(255, 161, 82, 236),
                                ),
                              ),
                            ),
                            Text("Gym")
                          ],
                        ),
                      )
                    ],
                  ),
                ),
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
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Card(
                                  elevation: 0.3,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white),
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
