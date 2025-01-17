import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'review_screen.dart';
import 'auth/login_screen.dart';
import '../main.dart';
import 'package:provider/provider.dart';
import 'notificationsManager/notificationsProvider.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userName = "";
  String userAge = "";
  String dogName = "";
  String dogBreed = "";
  bool profileCreated = true;

  bool notificationsEnabled = true;
  bool locationEnabled = true;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
  }

  Future<void> loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await ref.child('users/${user.uid}').once();
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        userName = data['name'] ?? "";
        userAge = data['age']?.toString() ?? "";
        dogName = data['dogName'] ?? "";
        dogBreed = data['dogBreed'] ?? "";
        profileCreated = data['profileCreated'] ?? false;
      });
    }
  }

  Future<void> saveProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await ref.child('users/${user.uid}').update({
        'name': userName,
        'age': int.tryParse(userAge) ?? 0,
        'dogName': dogName,
        'dogBreed': dogBreed,
        'profileCreated': true,
      });
    }
  }

  Future<void> resetPassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.email != null) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);
    }
  }

  void toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value;
    });
    themeNotifier.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void handleNotificationsToggle(bool value) {
    setState(() {
      notificationsEnabled = value;
    });
  }

  void handleLocationToggle(bool value) {
    setState(() {
      locationEnabled = value;
    });
  }

  // Método para confirmar o logout
  Future<void> _showLogoutConfirmationDialog() async {
    if (notificationsEnabled) {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );// Fecha a tela de configurações
                },
                child: Text('No'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.pink, BlendMode.srcIn),
                child: Image.asset("assets/dogpal-logo.png", height: 100,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                child: CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50, color: Colors.grey)
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => userName = value,
                controller: TextEditingController(text: userName),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onChanged: (value) => userAge = value,
                controller: TextEditingController(text: userAge),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Dog Name'),
                onChanged: (value) => dogName = value,
                controller: TextEditingController(text: dogName),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Dog Breed'),
                onChanged: (value) => dogBreed = value,
                controller: TextEditingController(text: dogBreed),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: saveProfileData,
                child: Text('Save Changes'),
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('Push Notifications'),
                value: notificationsEnabled,
                onChanged: handleNotificationsToggle,
              ),
              SwitchListTile(
                title: Text('Enable Location'),
                value: locationEnabled,
                onChanged: handleLocationToggle,
              ),
              SwitchListTile(
                title: Text('Dark Mode'),
                value: isDarkMode,
                onChanged: toggleDarkMode,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: resetPassword,
                    child: Text('Reset Password'),
                  ),
                  ElevatedButton(
                    onPressed: _showLogoutConfirmationDialog,  // Chama o método para confirmar o logout
                    child: Text('Sign Out'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//Manages the toggle notifications for the pages that use it.
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SwitchListTile(
        title: Text('Enable Notifications'),
        value: Provider.of<NotificationsProvider>(context).notificationsEnabled,
        onChanged: (value) {
          Provider.of<NotificationsProvider>(context, listen: false).toggleNotifications(value);
        },
      ),
    );
  }
}