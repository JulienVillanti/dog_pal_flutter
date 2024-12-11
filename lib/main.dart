import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled4/screens/auth/login_screen.dart';
import 'package:untitled4/screens/auth/signup_screen.dart';
import 'package:untitled4/screens/auth/home_wrapper.dart';
import 'package:untitled4/screens/home_screen.dart';

// import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      // home: AuthWrapper(),
      routes: {
        '/login': (context) => LoginScreen(),
        // '/signup': (context) => SignupScreen(),
        // '/home': (context) => HomeScreen(),
      },
    );
  }
}
