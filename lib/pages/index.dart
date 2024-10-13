import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takopedia/pages/add_product.dart';
import 'package:takopedia/pages/cart.dart';
import 'package:takopedia/pages/component/style.dart';
import 'package:takopedia/pages/forgot_password.dart';
import 'package:takopedia/pages/home.dart';

import 'package:takopedia/pages/menu.dart';
import 'package:takopedia/pages/order_list.dart';
import 'package:takopedia/services/auth_service.dart';
import 'package:takopedia/services/product_provider.dart';
import 'package:takopedia/services/user_provider.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> with SingleTickerProviderStateMixin {
  final _user = FirebaseAuth.instance.currentUser;
  final AuthService _auth = AuthService();

  int _tabIndex = 1;
  int get tabIndex => _tabIndex;
  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  late PageController pageController;

  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price));
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context).user;

    pageController = PageController(initialPage: 1);
    return Scaffold(
      bottomNavigationBar: CircleNavBar(
        activeIcons: const [
          Icon(Icons.restaurant_rounded,
              color: Color.fromARGB(255, 255, 255, 255)),
          Icon(Icons.home_rounded, color: Color.fromARGB(255, 255, 255, 255)),
          Icon(Icons.list_alt_rounded,
              color: Color.fromARGB(255, 255, 255, 255)),
        ],
        inactiveIcons: const [
          Text(
            "Menu",
            style: TextStyle(color: Colors.white, fontFamily: 'Poppins-Bold'),
          ),
          Text("Home",
              style:
                  TextStyle(color: Colors.white, fontFamily: 'Poppins-Bold')),
          Text(
            "Order",
            style: TextStyle(color: Colors.white, fontFamily: 'Poppins-Bold'),
          ),
        ],
        color: Color.fromARGB(255, 252, 79, 79),
        height: 70,
        circleWidth: 70,
        activeIndex: tabIndex,
        onTap: (index) {
          tabIndex = index;
          pageController.jumpToPage(tabIndex);
        },
        // padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: const Color.fromARGB(255, 187, 187, 187),
        elevation: 10,
      ),
      drawerScrimColor: const Color.fromARGB(117, 78, 78, 78),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userProvider?.nama ?? 'Quest'), // Nama pengguna
              accountEmail:
                  Text(_user!.email ?? "name@domain.com"), // Email pengguna
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
              title: const Text(
                'Keranjang Belanja',
                style: TextStyle(
                  color: Color.fromARGB(255, 51, 51, 51),
                  fontFamily: 'Poppins-regular',
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CartPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Riwayat Belanja', style: drawerTextStyle),
              onTap: () {
                // Tambahkan logika untuk navigasi ke halaman riwayat belanja
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting', style: drawerTextStyle),
              onTap: () {
                // Tambahkan logika untuk navigasi ke halaman pengaturan
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Halaman Login', style: drawerTextStyle),
              onTap: () {
                // Navigasi ke halaman login
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductPage()),
                );
              },
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height - 500,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout', style: drawerTextStyle),
              onTap: () {
                _auth.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: pageController,
          onPageChanged: (v) {
            setState(() {
              tabIndex = v;
            });
          },
          children: const [
            MenuPage(
              key: Key('measdafdfnu'),
            ),
            HomePage(
              key: Key('hoadfadfafme'),
            ),
            OrderListPage(
              key: Key('orddfafasdsder'),
            ),
          ],
        ),
      ),
    );
  }
}
