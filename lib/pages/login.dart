// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takopedia/model/user_model.dart';
import 'package:takopedia/pages/component/style.dart';
import 'package:takopedia/pages/forgot_password.dart';
import 'package:takopedia/services/auth_service.dart';
import 'package:takopedia/services/cart_provider.dart';
import 'package:takopedia/services/order_provider.dart';
import 'package:takopedia/services/product_provider.dart';
import 'package:takopedia/services/user_provider.dart';

import '../util/style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _obscureText = true;
  bool _isLoading = false;

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    setState(() {
      _isLoading = true;
    });
    //handle login
    try {
      final user = await _auth.signInWithEmailAndPassword(email, password);

      if (user != null && mounted) {
        Provider.of<ProductProvider>(context, listen: false).fetchProductList();
        Provider.of<OrderProvider>(context, listen: false).fetchOrder(user.uid);
        Provider.of<CartProvider>(context, listen: false)
            .fetchCartItem(user.uid);

        await fetchUserData(context);
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 1),
              backgroundColor: const Color.fromARGB(255, 38, 141, 41),
              content: Text(
                'Hi, ${userProvider.user!.nama}. Selamat Berbelanja',
                style: TextStyle(fontFamily: 'Poppins-regular', fontSize: 14),
              ),
            ),
          );

          Navigator.pushReplacementNamed(context, '/');
          setState(() {
            _isLoading = false;
          });
        }
        log('Logged in as ${user.email}');
      } else {
        log('Login failed');
      }
    } catch (e) {
      log("$e");

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${e.toString()}")));
    } finally {
      if (mounted) {}
    }
  }

  Future<Map<String, dynamic>?> getData(String uid) async {
    final data =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (data.exists) {
      return data.data();
    }
    return null;
  }

  Future<void> fetchUserData(BuildContext context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    if (currentUser != null) {
      String uid = currentUser.uid;
      Map<String, dynamic>? userData = await getData(uid);

      if (userData != null) {
        UserModel userModel = UserModel.fromMap(userData);
        userProvider.setUser(userModel);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 220, 220),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                // Gambar latar belakang
                SizedBox(
                  width: screenWidth,
                  height: screenHeight,
                ),

                // Konten halaman login di atas background
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 200,
                          ),

                          // Logo berbentuk lingkaran
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50,
                            backgroundImage: AssetImage('assets/img/logo.png'),
                          ),

                          const SizedBox(height: 70),

                          // TextField email dengan desain kapsul dan ikon email
                          SizedBox(
                            width: 300,
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // TextField password dengan ikon mata untuk menampilkan/menyembunyikan password
                          SizedBox(
                            width: 300,
                            child: TextField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),

                          // Link Lupa Password di bawah isian Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordPage()),
                                );
                              },
                              child: const Text(
                                'Lupa Password?',
                                style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    color: Color.fromARGB(255, 230, 64, 64)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Tombol login dan register dalam satu row
                          ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  const Size(240, 42)),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 226, 140, 140)),
                              elevation: MaterialStateProperty.all(2),
                            ),
                            onPressed: () {
                              _login();
                            },
                            child: const Text(
                              'Login',
                              style: loginbuttonTextStyle,
                            ),
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: Color.fromARGB(255, 236, 147, 147)),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Login dengan sosial media
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
