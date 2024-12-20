import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:untitled4/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.pink, BlendMode.srcIn),
                child: Image.asset("assets/dogpal-logo.png", height: 100,
                ),
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.pink,
                              width: 2.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.pink,
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: (value) =>
                      value?.isEmpty ?? true
                          ? 'Email field cannot be empty'
                          : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Color.fromARGB(0xFF, 0xAE, 0X53, 0x53),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Color.fromARGB(0xFF, 0xAE, 0X53, 0x53),
                            width: 1.5,
                          ),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) =>
                      value?.isEmpty ?? true
                          ? 'Password field cannot be empty'
                          : null,
                    ),
                    SizedBox(height: 24),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.pink,
                          overlayColor: Colors.red),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: Text(
                        'Don\'t have an account? Sign up',
                        style: TextStyle(
                          color: Colors.pink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Show to Julien later the changes on his page!!

  // Future<void> _handleLogin() async {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     setState(() => _isLoading = true);
  //     try {
  //       await _authService.signInWithEmailPassword(
  //         _emailController.text,
  //         _passwordController.text,
  //       );
  //
  //       Navigator.pushReplacementNamed(context, '/home');


      Future<void> _handleLogin() async {
          if (_formKey.currentState?.validate() ?? false) {
            setState(() => _isLoading = true);

            try {
              // Fazer login com email e senha
              final UserCredential? userCredential = await _authService
                  .signInWithEmailPassword(
                _emailController.text,
                _passwordController.text,
              );

              // Obter ID do usuário logado
              final userId = userCredential?.user?.uid;

              if (userId != null) {
                // Referência ao Firebase Database
                final userRef = FirebaseDatabase.instance
                    .ref()
                    .child('users')
                    .child(userId);

                // Verificar o status do perfil
                final snapshot = await userRef.once();
                final userData = snapshot.snapshot.value as Map?;
                final profileCreated = userData?['profileCreated'] ?? false;

                if (profileCreated) {
                  // Redirecionar para HomeScreen
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  // Redirecionar para ProfileCreationScreen
                  Navigator.pushReplacementNamed(context, '/profile_creation');
                }
              } else {
                throw Exception("User ID is null.");
              }
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.toString())),
              );
            } finally {
              setState(() => _isLoading = false);
            }
          }
        }

        @override
        void dispose() {
          _emailController.dispose();
          _passwordController.dispose();
          super.dispose();
  }
}
