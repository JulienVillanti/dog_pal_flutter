import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserProfileCreationView extends StatefulWidget {
  @override
  _UserProfileCreationViewState createState() => _UserProfileCreationViewState();
}

class _UserProfileCreationViewState extends State<UserProfileCreationView> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userAgeController = TextEditingController();
  final TextEditingController _dogNameController = TextEditingController();
  final TextEditingController _dogBreedController = TextEditingController();

  File? _userImage;

  final ImagePicker _picker = ImagePicker();

  bool _isSubmitting = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _userImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateUserProfileStatus() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      final userRef = FirebaseDatabase.instance.ref().child('users').child(uid);

      final userData = {
        "profileCreated": true,
        "userName": _userNameController.text,
        "userEmail": _userEmailController.text,
        "userAge": _userAgeController.text,
        "dogName": _dogNameController.text,
        "dogBreed": _dogBreedController.text,
        "userImage": _userImage != null ? _userImage!.path : null,
      };

      await userRef.update(userData);
      Navigator.pushReplacementNamed(context, '/homeScreen');
    } catch (e) {
      print("Failed to update profile status: $e");
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set up your account'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo
            Image.asset(
              'assets/DogPalLogo2.png',
              height: 150,
            ),

            SizedBox(height: 16.0),

            // Input fields
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: 'Your Name'),
            ),
            TextField(
              controller: _userEmailController,
              decoration: InputDecoration(labelText: 'Your Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _userAgeController,
              decoration: InputDecoration(labelText: 'Your Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _dogNameController,
              decoration: InputDecoration(labelText: 'Dog Name'),
            ),
            TextField(
              controller: _dogBreedController,
              decoration: InputDecoration(labelText: 'Dog Breed'),
            ),

            SizedBox(height: 16.0),

            // Image picker
            Text("Insert a picture of yourself! (optional)"),
            SizedBox(height: 8.0),
            _userImage != null
                ? CircleAvatar(
              radius: 50,
              backgroundImage: FileImage(_userImage!),
            )
                : TextButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.camera_alt, color: Colors.brown),
              label: Text(
                'Select a Photo',
                style: TextStyle(color: Colors.brown),
              ),
            ),

            SizedBox(height: 16.0),

            // Submit button
            ElevatedButton(
              onPressed: _isSubmitting
                  ? null
                  : (_userNameController.text.isEmpty ||
                  _userEmailController.text.isEmpty ||
                  _userAgeController.text.isEmpty ||
                  _dogNameController.text.isEmpty ||
                  _dogBreedController.text.isEmpty)
                  ? null
                  : _updateUserProfileStatus,
              child: _isSubmitting
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Submit your Info'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
