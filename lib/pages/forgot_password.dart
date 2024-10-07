import 'package:flutter/material.dart';
import 'package:takopedia/services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _auth = AuthService();
  Future<void> _resetPassword() async {
    // Implementasikan logika untuk mengirim email reset password
    _auth.sendEmailforResetPassword(_emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Lupa Password')),
      body: Stack(
        children: [
          // Gambar latar belakang

          // Konten di atas gambar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo di bagian atas
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/img/logo.png'), // Sesuaikan dengan path logo
                  ),
                ),
                const SizedBox(height: 24),

                // Pesan di bawah logo, margin sama dengan input email
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    child: const Text(
                      'Lupa Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.black, // Teks berwarna putih agar kontras
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Pesan "Pesan:", margin sejajar dengan isian email
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    child: const Text(
                      'Pesan:',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black, // Teks berwarna putih
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                // Deskripsi pesan dengan margin kiri kanan sejajar isian email
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    child: const Text(
                      'Masukkan email Anda dan tunggu kode etik akan dikirimkan.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black, // Teks berwarna putih
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // TextField email dengan desain kapsul dan ikon email
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.8, // Ukuran lebar menyesuaikan layar
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Masukkan Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        filled: true,
                        fillColor: Colors.white
                            .withOpacity(0.8), // Transparansi untuk kontras
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Reset Password
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.6,
                    child: ElevatedButton(
                      onPressed: _resetPassword,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Bentuk kapsul
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16), // Ukuran tinggi tombol
                      ),
                      child: const Text('Reset Password'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Pesan error atau status
              ],
            ),
          ),
        ],
      ),
    );
  }
}
