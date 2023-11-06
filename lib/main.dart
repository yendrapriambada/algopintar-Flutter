import 'dart:async';

import 'package:algopintar/screens/landing_page_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'services/user_auth/firebase_auth/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget getInitialRoute(double screenWidth) {
    if (screenWidth > 700) {
      return const LoginScreen();
    } else {
      if (FirebaseAuth.instance.currentUser == null) {
        print('user is null');
        return const LandingPage(); // User is signed out
      } else {
        print('user is not null');
        return const MainScreen(); // User is signed in
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      // initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/home',
      title: 'Algo Pintar',
      theme: ThemeData(),
      // home: LoginScreen(),
      routes: {
        '/': (context) => SplashScreen(
              child: getInitialRoute(screenWidth),
            ),
        '/landingPage': (context) => const LandingPage(),
        '/login': (context) => const LoginScreen(),
        '/signUp': (context) => const SignupScreen(),
        '/home': (context) => const MainScreen(),
      },
    );
  }
}
