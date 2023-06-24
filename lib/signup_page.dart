import 'package:example/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'chat_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  Color myRed = const Color(0xffff2d2d);
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService(FirebaseAuth.instance);
  String _email = '';
  String _password = '';
  String _name = '';
  int? _age;
  String _phoneNumber = '';
  String? _occupation;
  String? _address;

  final List<String> _occupations = [
    'Software Developer',
    'Doctor',
    'Teacher',
    'Engineer',
    'Designer',
  ];

  final List<String> _addresses = [
    'Istanbul',
    'Ankara',
    'Izmir',
  ];

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: myRed),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: myRed),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WelcomePage()),
            );
          },
        ),
        backgroundColor: myRed,
        elevation: 0, // removes the shadow under the AppBar
      ),
      backgroundColor: myRed,
      body: Column(
        children: <Widget>[
          const Expanded(
            flex: 1,
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
            flex: 6,
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
                            return 'Email adresinizi giriniz.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: _buildInputDecoration('Şifre'),
                        obscureText: true,
                        onChanged: (value) => _password = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Şifrenizi giriniz.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: _buildInputDecoration('Adı Soyadı'),
                        onChanged: (value) => _name = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'İsminizi giriniz.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: _buildInputDecoration('Yaş'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => _age = int.tryParse(value),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Yaşınızı giriniz.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: _buildInputDecoration('Telefon Numarası'),
                        keyboardType: TextInputType.phone,
                        onChanged: (value) => _phoneNumber = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Telefon numaranızı giriniz.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: _occupation,
                        decoration: _buildInputDecoration('Meslek'),
                        items: _occupations.map((String occupation) {
                          return DropdownMenuItem<String>(
                            value: occupation,
                            child: Text(occupation),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _occupation = value),
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: _address,
                        decoration: _buildInputDecoration('İkamet Şehri'),
                        items: _addresses.map((String address) {
                          return DropdownMenuItem<String>(
                            value: address,
                            child: Text(address),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _address = value),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: myRed,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text('Üye Ol', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _authService.signUp(email: _email, password: _password);

        CollectionReference users = FirebaseFirestore.instance.collection('users');
        await users.doc(userCredential.user!.uid).set({
          'email' : _email,
          'name': _name,
          'age': _age,
          'phoneNumber': _phoneNumber,
          'occupation': _occupation,
          'address': _address,
        });

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChatPage()));

      } catch (e) {
        print(e);
      }
    }
  }

}
