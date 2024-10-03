import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:takopedia/services/authService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true; // Untuk menyembunyikan/menampilkan password
  String _message = '';
  final AuthService _auth = AuthService();

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    //handle login
    final user = await _auth.signInWithEmailAndPassword(email, password);
    if (user != null) {
      print('Logged in as ${user.email}');
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      print('Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Gambar latar belakang
          Container(
            width: screenWidth,
            height: screenHeight,
          ),

          // Konten halaman login di atas background
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo berbentuk lingkaran
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    backgroundImage: AssetImage('assets/img/logo.png'),
                  ),
                  SizedBox(height: 24),

                  // TextField email dengan desain kapsul dan ikon email
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // TextField password dengan ikon mata untuk menampilkan/menyembunyikan password
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
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
                              builder: (context) => Placeholder()),
                        );
                      },
                      child: Text(
                        'Lupa Password?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Tombol login dan register dalam satu row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _login,
                        child: Text('Login'),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        child: Text('Register'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Pesan error
                  Text(
                    _message,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 100),

                  // Login dengan sosial media
                  Text(
                    "Atau login dengan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage('assets/img/google.png'),
                        ),
                      ),
                      // SizedBox(width: 20),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: CircleAvatar(
                      //     radius: 25,
                      //     backgroundImage:
                      //         AssetImage('assets/images/facebook_logo.png'),
                      //   ),
                      // ),
                      // SizedBox(width: 20),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: CircleAvatar(
                      //     radius: 25,
                      //     backgroundImage:
                      //         AssetImage('assets/images/linkedin_logo.png'),
                      //   ),
                      // ),
                      // SizedBox(width: 20),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: CircleAvatar(
                      //     radius: 25,
                      //     backgroundImage:
                      //         AssetImage('assets/images/twitter_logo.png'),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
