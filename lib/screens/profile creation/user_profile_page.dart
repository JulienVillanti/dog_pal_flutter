import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userName = "Unknown User";
  String userAge = "0";
  String userEmail = "No Email";
  String dogName = "No Dog Name";
  String dogBreed = "No Breed";
  String? userImageURL;
  bool navigateToLogin = false;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          final data = userDoc.data()!;
          setState(() {
            userName = data['name'] ?? "Unknown User";
            userEmail = data['email'] ?? "No Email";
            userAge = (data['age'] ?? 0).toString();
            dogName = data['dogName'] ?? "No Dog Name";
            dogBreed = data['dogBreed'] ?? "No Breed";
            userImageURL = data['userImage']; // URL da imagem do Firebase Storage
          });
        }
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  Future<void> signOutFirebase() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/login'); // Direciona para Login
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Logo
            Image.asset(
              'assets/images/DogPalLogo2.png',
              width: 250,
              height: 100,
            ),
            SizedBox(height: 20),
            // User Image
            CircleAvatar(
              radius: 60,
              backgroundImage:
              userImageURL != null ? NetworkImage(userImageURL!) : null,
              child: userImageURL == null
                  ? Icon(Icons.person, size: 80, color: Colors.grey)
                  : null,
            ),
            SizedBox(height: 10),
            // User Name
            Text(
              userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // User Details
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Column(
                children: [
                  DetailRow(title: "Email", value: userEmail, color: Colors.blue),
                  DetailRow(title: "Age", value: userAge, color: Colors.green),
                  DetailRow(title: "Dog Name", value: dogName, color: Colors.purple),
                  DetailRow(title: "Dog Breed", value: dogBreed, color: Colors.orange),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Logout Button
            ElevatedButton(
              onPressed: () => _showSignOutDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: 5,
              ),
              child: Text(
                "Sign Out",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

