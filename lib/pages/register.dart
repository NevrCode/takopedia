// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:takopedia/util/style.dart';

import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  File? _profilePic;
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilePic = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _register() async {
    final email = _emailController.text;
    final pass = _passwordController.text;
    final nama = _namaController.text;
    final alamat = _alamatController.text;
    final telp = _teleponController.text;

    // await _saveImage(); // Simpan gambar sebelum registrasi

    if (_profilePic != null) {
      final user = await _authService.registerWithEmailandDetail(
        email,
        pass,
        nama,
        alamat,
        _profilePic!.path,
        telp,
      );
      if (user != null) {
        log('user registered with uid : ${user.uid}');
      } else if (user == null) {
        log('Registration Failed');
      } else {
        log("entah");
      }
    } else {
      log('Please select a profile picture');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 206, 190, 190),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 80, 0, 70),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(255, 252, 252, 252),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 241, 228, 228),
                    radius: 50,
                    backgroundImage:
                        _profilePic != null ? FileImage(_profilePic!) : null,
                    child: _profilePic == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Color.fromARGB(255, 255, 255, 255),
                          )
                        : null, // Tampilkan icon person jika belum ada foto
                  ),
                  const SizedBox(height: 16),

                  if (_profilePic != null)
                    Text(
                      'Nama file: ${_namaController.text.split(" ")[0]}.jpg',
                      style: const TextStyle(fontSize: 14),
                    ),
                  const SizedBox(height: 16),

                  // Tombol Upload Foto
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(150, 42)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 226, 140, 140)),
                      elevation: MaterialStateProperty.all(2),
                    ),
                    onPressed: () {
                      _pickProfilePicture();
                    },
                    child: const Text(
                      'Upload image',
                      style: loginbuttonTextStyle,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                    child: SizedBox(
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          labelStyle: const TextStyle(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                    child: SizedBox(
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 243, 103, 103)),
                          prefixIcon: const Icon(
                            Icons.lock_rounded,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                    child: SizedBox(
                      child: TextField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 243, 103, 103)),
                          prefixIcon: const Icon(
                            Icons.person,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                    child: SizedBox(
                      child: TextField(
                        maxLines: 3,
                        textAlignVertical: TextAlignVertical.top,
                        textAlign: TextAlign.start,
                        controller: _alamatController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 243, 103, 103)),
                          prefixIcon: const Icon(
                            Icons.location_pin,
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
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          filled: true,
                          fillColor: Color.fromARGB(255, 248, 248, 248),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                    child: SizedBox(
                      child: TextField(
                        controller: _teleponController,
                        decoration: InputDecoration(
                          labelText: 'Telp',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 243, 103, 103)),
                          prefixIcon: const Icon(
                            Icons.numbers,
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
                              const EdgeInsets.symmetric(horizontal: 0),
                          filled: true,
                          fillColor: Color.fromARGB(255, 248, 248, 248),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Foto dalam bentuk lingkaran

                  // Tombol Register
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(const Size(150, 42)),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 255, 252, 252)),
                            elevation: MaterialStateProperty.all(0),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontSize: 15,
                              color: Color.fromARGB(255, 243, 148, 148),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(const Size(150, 42)),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 226, 140, 140)),
                            elevation: MaterialStateProperty.all(2),
                          ),
                          onPressed: () async {
                            try {
                              await _register();
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "[${e.code}] Email atau Password salah"),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Email atau Password salah"),
                                ),
                              );
                            }
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            'Register',
                            style: loginbuttonTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
