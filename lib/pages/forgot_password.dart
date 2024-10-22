import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:takopedia/services/auth_service.dart';
import 'package:takopedia/util/style.dart';

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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 252, 252),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 180, 0, 180),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontFamily: 'Poppins-bold',
                        fontSize: 20,
                        color: Color.fromRGBO(41, 41, 41, 1),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Isikan alamat e-mail kamu di bawah, kami akan kirimkan e-mail untuk kamu me-reset passwordnya",
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 15,
                        color: Color.fromARGB(255, 44, 44, 44),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // TextField email dengan desain kapsul dan ikon email
                    SizedBox(
                      width: 350,
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 245, 182, 182)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          filled: true,
                          fillColor: Color.fromARGB(255, 248, 248, 248),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

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
                        _auth.sendEmailforResetPassword(_emailController.text);
                        Fluttertoast.showToast(
                          msg: "Silahkan cek e-mail kamu <3",
                          backgroundColor: Color.fromARGB(255, 187, 121, 121),
                        );
                        _emailController.clear();
                      },
                      child: const Text(
                        'Reset Password',
                        style: loginbuttonTextStyle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Back',
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
      ),
    );
  }
}
