import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'review_screen.dart';


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
        final userRef = FirebaseDatabase.instance.ref().child('users/${user.uid}');
        final snapshot = await userRef.get();

        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;
          setState(() {
            userName = data['name'] ?? "Unknown User";
            userEmail = data['email'] ?? "No Email";
            userAge = (data['age'] ?? 0).toString();
            dogName = data['dogName'] ?? "No Dog Name";
            dogBreed = data['dogBreed'] ?? "No Breed";
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

  // Método para confirmar o logout
  Future<void> _showLogoutConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Would you like to leave a comment on a park?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navegar para a tela de revisão
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewScreen()),
                );
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Fazer o logoff
                await _auth.signOut();
                Navigator.of(context).pop();  // Fecha a tela de configurações
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.pink, BlendMode.srcIn),
              child: Image.asset("assets/dogpal-logo.png", height: 100,
              ),
            ),
            SizedBox(height: 20),
            // User Image
            CircleAvatar(
              radius: 60,
              child: Icon(Icons.person, size: 80, color: Colors.grey),
              backgroundColor: Colors.grey[200],
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
              onPressed: () => _showLogoutConfirmationDialog(),
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
  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sign Out"),
        content: Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              signOutFirebase();
            },
            child: Text("Sign Out"),
          ),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const DetailRow({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            "$title:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Spacer(),
          Text(value),
        ],
      ),
    );
  }
}
