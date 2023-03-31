import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  Color myRed = const Color(0xffff2d2d);
  final _formKey = GlobalKey<FormState>();
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
    'İzmir',
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
      backgroundColor: myRed,
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
                        decoration: _buildInputDecoration('Name'),
                        onChanged: (value) => _name = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: _buildInputDecoration('Age'),
                        onChanged: (value) {
                          _age = int.tryParse(value) ?? 0;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your age';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: _buildInputDecoration('+05051112233'),
                        obscureText: true,
                        onChanged: (value) => _phoneNumber = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        decoration: _buildInputDecoration('Occupation'),
                        items: _occupations.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _occupation = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an occupation';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        decoration: _buildInputDecoration('City'),
                        items: _addresses.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _address = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _submitForm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: myRed,
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
        backgroundColor: myRed,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        CollectionReference users = FirebaseFirestore.instance.collection('users');
        await users.add({
          'name': _name,
          'age': _age,
          'phoneNumber': _phoneNumber,
          'occupation': _occupation,
          'address': _address,
        });

        // Navigate to the next page or show a success message
      } catch (e) {
        print(e);
      }
    }
  }
}
