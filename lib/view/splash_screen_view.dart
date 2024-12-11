// splash_screen_view.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'onboarding_screen_view.dart'; // Import the Onboarding screen

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();

    // Wait for 3 seconds, then navigate to the Onboarding Screen
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreenView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png', // Add your logo here
          width: 200, // Adjust size if needed
          height: 200,
        ),
      ),
    );
  }
}
