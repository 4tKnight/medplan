import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        "./assets/splash.png",
        fit: BoxFit.cover,
        width: double.maxFinite,
        height: double.maxFinite,
      ),
    );
  }
}
