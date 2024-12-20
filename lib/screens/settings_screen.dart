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
      isDarkMode = Theme
          .of(context)
          .brightness == Brightness.dark;
    }
    Future<void> loadUserProfile() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await ref.child('users/${user.uid}').once();
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
                  ]
              )
          ),
        ),
      );
    }
  }
