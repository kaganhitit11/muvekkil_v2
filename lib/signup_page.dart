import 'package:example/personal_info_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'welcome_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService(FirebaseAuth.instance);
  String _email = '';
  String _password = '';

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Color(0xffff2d2d)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Color(0xffff2d2d)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffff2d2d),
      body: Column(
        children: <Widget>[
          const Expanded(
            flex: 2,
            child: Center(
              child: Text(
                'Müvekkil',
                style: TextStyle(
                    fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: const Text(
              'Üye Ol',
              style: TextStyle(
                  fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      TextFormField(
                        decoration: _buildInputDecoration('Email'),
                        onChanged: (value) => _email = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: _buildInputDecoration('Password'),
                        obscureText: true,
                        onChanged: (value) => _password = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await _authService.signUp(email: _email, password: _password);
                              // ignore: use_build_context_synchronously
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return const PersonalInfoPage(
                                );
                              })
                              );
                            } on FirebaseAuthException catch (e) {
                              print(e.message);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffff2d2d),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text('Üye Ol', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffff2d2d),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomePage()),
          );
        },
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}