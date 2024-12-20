import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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


  bool _isSubmitting = false;
  bool _isButtonEnabled = false;

  void _validateFields() {
    setState(() {
      _isButtonEnabled = _userNameController.text.isNotEmpty &&
          _userEmailController.text.isNotEmpty &&
          _userAgeController.text.isNotEmpty &&
          _dogNameController.text.isNotEmpty &&
          _dogBreedController.text.isNotEmpty;
    });
  }

  Future<void> _updateUserProfileStatus() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Atualizar os dados no Firebase ou fazer o que for necessário para submeter os dados
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userRef = FirebaseDatabase.instance.ref().child('users/${user.uid}');
        await userRef.update({
          'name': _userNameController.text,
          'email': _userEmailController.text,
          'age': _userAgeController.text,
          'dogName': _dogNameController.text,
          'dogBreed': _dogBreedController.text,
          'profileCreated': true,
        });
      }

      // Após a atualização bem-sucedida, navegue para a Home
      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro ao atualizar perfil: $error")));
    } finally {
      setState(() {
        _isSubmitting = false; // Desabilitar o estado de carregamento
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Add listeners to validate fields on input change
    _userNameController.addListener(_validateFields);
    _userEmailController.addListener(_validateFields);
    _userAgeController.addListener(_validateFields);
    _dogNameController.addListener(_validateFields);
    _dogBreedController.addListener(_validateFields);
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    _userNameController.dispose();
    _userEmailController.dispose();
    _userAgeController.dispose();
    _dogNameController.dispose();
    _dogBreedController.dispose();
    super.dispose();
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
            ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.pink, BlendMode.srcIn),
              child: Image.asset("assets/dogpal-logo.png", height: 100,
              ),
            ),
            SizedBox(height: 30),

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

            ElevatedButton(
              onPressed: _isSubmitting || !_isButtonEnabled
                  ? null
                  : _updateUserProfileStatus,
              child: _isSubmitting
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Submit your Info'),
              style: ElevatedButton.styleFrom(
                backgroundColor:  _isButtonEnabled ? Colors.pink[100] : Colors.grey,
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
