import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  // Fungsi untuk menyimpan gambar ke folder yang dapat diakses
  // Future<void> _saveImage() async {
  //   if (_profilePic != null) {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final String imageName =
  //         '${_namaController.text.split(" ")[0]}.jpg'; // Ambil nama depan
  //     final String newPath = '${directory.path}/$imageName'; // Path baru

  //     await _profilePic!.copy(newPath);
  //     log(
  //         'Image saved to: $newPath'); // Debugging untuk memastikan penyimpanan
  //   }
  // }

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
      // log('${Platform.operatingSystem}');
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
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  prefixIcon: const Icon(Icons.home),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                ),
                minLines: 3,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _teleponController,
                decoration: InputDecoration(
                  labelText: 'Telepon',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 16),

              // Foto dalam bentuk lingkaran
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    _profilePic != null ? FileImage(_profilePic!) : null,
                child: _profilePic == null
                    ? const Icon(Icons.person, size: 50)
                    : null, // Tampilkan icon person jika belum ada foto
              ),
              const SizedBox(height: 16),

              // Hanya menampilkan nama file
              if (_profilePic != null)
                Text(
                  'Nama file: ${_namaController.text.split(" ")[0]}.jpg',
                  style: const TextStyle(fontSize: 14),
                ),
              const SizedBox(height: 16),

              // Tombol Upload Foto
              ElevatedButton(
                onPressed: _pickProfilePicture,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text('Upload Foto'),
              ),
              const SizedBox(height: 16),

              // Tombol Register
              ElevatedButton(
                onPressed: () {
                  _register();
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text('Register'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
