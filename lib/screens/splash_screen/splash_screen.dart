import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;

  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.child!),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0XFF5D60E2),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 140,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Image.asset(
                      'images/app_icon.png',
                      fit: BoxFit.cover,
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: const Text(
                  'Pintar Informatika',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 6),
                child: const Text(
                  'Raih Keahlian Algoritma dengan Cerdas',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ));
  }
}
