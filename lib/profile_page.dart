import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Color myRed = const Color(0xffff2d2d);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    print("User id is : " + uid);
    _user = await getUserData(uid);
    setState(() {});
  }

  Future<void> _changePassword() async {
    String _currentPassword = '';
    String _newPassword = '';
    final _auth = FirebaseAuth.instance;
    final _formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text('Parolamı Güncelle', style: TextStyle(color: myRed, fontSize: 24)),
          ),
          shape: RoundedRectangleBorder(  // Set shape property
            borderRadius: BorderRadius.circular(15),  // provide a value for the radius
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Mevcut Parola'),
                    obscureText: true,
                    onChanged: (value) => _currentPassword = value,
                    validator: (value) => value!.isEmpty ? 'Lütfen mevcut parolanızı giriniz' : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Yeni Parola'),
                    obscureText: true,
                    onChanged: (value) => _newPassword = value,
                    validator: (value) => value!.isEmpty ? 'Lütfen yeni parolanızı giriniz' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('İptal', style: TextStyle(color: myRed, fontSize: 18)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Güncelle', style: TextStyle(color: myRed, fontSize: 18)),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    AuthCredential credential = EmailAuthProvider.credential(
                      email: _user!.email,
                      password: _currentPassword,
                    );
                    await _auth.currentUser!.reauthenticateWithCredential(credential);
                    await _auth.currentUser!.updatePassword(_newPassword);
                    Navigator.of(context).pop();
                  } catch (e) {
                    print(e);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }



  Future<UserModel> getUserData(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return UserModel.fromDocumentSnapshot(doc);
  }

  @override
  Widget build(BuildContext context) {
    Color myRed = const Color(0xffff2d2d);
    return Scaffold(
      backgroundColor: myRed,
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
              "Müvekkil",
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center
          ),
        ),
        backgroundColor: myRed,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: <Widget>[
          const Expanded(
            flex: 2,
            child: Center(
              child: Text(
                'Profilim',
                style: TextStyle(
                    fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white),
              ),
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
              child: _user == null
                  ? CircularProgressIndicator() // Show loading indicator while fetching user data
                  : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    ProfileField(
                      fieldName: 'Adı Soyadı',
                      fieldValue: _user!.name,
                    ),
                    const SizedBox(height: 20),
                    ProfileField(
                      fieldName: 'Yaş',
                      fieldValue: _user!.age.toString(),
                    ),
                    const SizedBox(height: 20),
                    ProfileField(
                      fieldName: 'Telefon Numarası',
                      fieldValue: _user!.phoneNumber,
                    ),
                    const SizedBox(height: 20),
                    ProfileField(
                      fieldName: 'İkamet Adresi',
                      fieldValue: _user!.address,
                    ),
                    const SizedBox(height: 20),
                    ProfileField(
                      fieldName: 'Meslek',
                      fieldValue: _user!.occupation,
                    ),
                    const SizedBox(height: 20),
                    ProfileField(
                      fieldName: 'Email',
                      fieldValue: _user!.email,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: myRed,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text('Parolamı Güncelle', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserModel {
  final String name;
  final int age;
  final String phoneNumber;
  final String address;
  final String occupation;
  final String email;

  UserModel({
    required this.name,
    required this.age,
    required this.phoneNumber,
    required this.address,
    required this.occupation,
    required this.email,
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return UserModel(
      name: doc['name'],
      age: doc['age'],
      phoneNumber: doc['phoneNumber'],
      address: doc['address'],
      occupation: doc['occupation'],
      email: doc['email'],
    );
  }
}

class ProfileField extends StatelessWidget {
  final String fieldName;
  final String fieldValue;

  ProfileField({required this.fieldName, required this.fieldValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              fieldName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              fieldValue,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
