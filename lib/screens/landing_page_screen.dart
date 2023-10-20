import 'package:algopintar/screens/login_screen.dart';
import 'package:algopintar/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 800) {
          return const LandingPageMobile();
        } else {
          return const LandingPageMobile();
        }
      },
    );
  }
}

class LandingPageMobile extends StatelessWidget {
  const LandingPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            height: 180,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Image.asset(
                'images/app_icon.png',
                fit: BoxFit.cover,
              ),
            )
        ),
        Container(
          margin: const EdgeInsets.only(top: 16),
          child: const Text(
            'Algo Pintar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: const Text(
            'AlgoPintar merupakan sebuah platform media pembelajaran bagi siswa yang ingin mempelajari dasar keilmuan pemrograman. Aplikasi ini dilengkapi dengan materi, latihan soal, progress belajar, dan papan peringkat.',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: 250,
          height: 50,
          margin: const EdgeInsets.only(top: 16),
          child: SizedBox(
            width: 1,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D60E2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
                // padding: EdgeInsets.all(18),
              ),
              child: const Text(
                'Login',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ),
          )
        ),

        Container(
            width: 250,
            height: 50,
            margin: const EdgeInsets.only(top: 16),
            child: SizedBox(
              width: 1,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(width: 1.0, color: Color(0xFF5D60E2)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Signup'),
              )
            )
        ),
      ],
    ));
  }
}
