import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  String userName = "";
  String userEmail = "";
  String userAge = "";
  String dogName = "";
  String dogBreed = "";
  bool profileCreated = true;

  XFile? userImage;
  bool notificationsEnabled = true;
  bool locationEnabled = true;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
  }

  Future<void> loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await ref.child('dogOwners/${user.uid}').once();
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        userName = data['name'] ?? "";
        userEmail = data['email'] ?? "";
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
      await ref.child('dogOwners/${user.uid}').set({
        'name': userName,
        'email': userEmail,
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

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        userImage = image;
      });
    }
  }

  void toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value;
    });
    // Implementar lógica para persistir o tema se necessário
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/DogPalLogo2.png',
                  width: 350,
                  height: 150,
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: userImage != null
                      ? FileImage(File(userImage!.path))
                      : null,
                  child: userImage == null
                      ? Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => userName = value,
                controller: TextEditingController(text: userName),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) => userEmail = value,
                controller: TextEditingController(text: userEmail),
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
              ElevatedButton(
                onPressed: resetPassword,
                child: Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
