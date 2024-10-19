import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takopedia/pages/add_product.dart';
import 'package:takopedia/pages/cart.dart';

import 'package:takopedia/pages/history.dart';
import 'package:takopedia/pages/home.dart';

import 'package:takopedia/pages/menu.dart';
import 'package:takopedia/pages/order_list.dart';
import 'package:takopedia/services/auth_service.dart';
import 'package:takopedia/services/user_provider.dart';

import '../util/style.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

const _navBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home_rounded),
    activeIcon: Icon(Icons.home_rounded),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.restaurant_menu_outlined),
    activeIcon: Icon(Icons.restaurant_menu_rounded),
    label: 'Menu',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.list_alt),
    activeIcon: Icon(Icons.list_alt_outlined),
    label: 'Order',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.history),
    activeIcon: Icon(Icons.history_rounded),
    label: 'History',
  ),
];

class _IndexState extends State<Index> with SingleTickerProviderStateMixin {
  final _user = FirebaseAuth.instance.currentUser;
  final AuthService _auth = AuthService();

  int _tabIndex = 0;
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        iconSize: 27,
        selectedLabelStyle: TextStyle(fontFamily: 'Poppins-bold'),
        unselectedLabelStyle: TextStyle(fontFamily: 'Poppins-regular'),
        selectedItemColor: Color.fromARGB(255, 240, 94, 94),
        unselectedItemColor: Color.fromARGB(255, 165, 145, 145),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
            pageController.jumpToPage(index);
          });
        },
        items: _navBarItems,
      ),
      drawerScrimColor: Color.fromARGB(117, 88, 88, 88),
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
                color: Color.fromARGB(255, 177, 132, 132),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HistoryPage()));
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
            HomePage(
              key: Key('hoadfadfafme'),
            ),
            MenuPage(
              key: Key('measdafdfnu'),
            ),
            OrderListPage(
              key: Key('orddfafasdsder'),
            ),
            HistoryPage(),
          ],
        ),
      ),
    );
  }
}
