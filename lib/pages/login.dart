// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takopedia/model/user_model.dart';
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
              backgroundColor: Color.fromARGB(255, 242, 255, 242),
              content: Text(
                'Hi, ${userProvider.user!.nama}. Selamat Berbelanja',
                style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14,
                    color: Color.fromARGB(255, 61, 223, 83)),
              ),
            ),
          );

          Navigator.pushReplacementNamed(context, '/');
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
    return Scaffold(
      backgroundColor:
          _isLoading ? Colors.white : Color.fromARGB(255, 212, 204, 204),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 247, 130, 130),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 180, 0, 180),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        // Logo berbentuk lingkaran
                        Image.asset(
                          'assets/img/logo.png',
                          width: 60,
                        ),

                        const SizedBox(height: 40),

                        // TextField email dengan desain kapsul dan ikon email
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'E-mail',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 243, 103, 103)),
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Color.fromARGB(255, 247, 129, 129),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 245, 182, 182)),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              filled: true,
                              fillColor: Color.fromARGB(255, 248, 248, 248),
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
                              iconColor: const Color.fromARGB(26, 168, 73, 73),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 243, 103, 103)),
                              prefixIcon: const Icon(Icons.lock,
                                  color: Color.fromARGB(255, 247, 129, 129)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Color.fromARGB(255, 247, 129, 129),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 245, 182, 182)),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              filled: true,
                              fillColor: Color.fromARGB(255, 248, 248, 248),
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
                                  color: Color.fromARGB(255, 235, 109, 109)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Tombol login dan register dalam satu row
                        ElevatedButton(
                          style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(const Size(240, 42)),
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

                        const SizedBox(height: 30),

                        // Login dengan sosial media
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
