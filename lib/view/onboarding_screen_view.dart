import 'package:flutter/material.dart';
import 'package:linkora_app/view/login_screen_view.dart';
import 'package:linkora_app/view/signup_screen_view.dart';

class OnboardingScreenView extends StatefulWidget {
  const OnboardingScreenView({super.key});

  @override
  State<OnboardingScreenView> createState() => _OnboardingScreenViewState();
}

class _OnboardingScreenViewState extends State<OnboardingScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background shapes
          Positioned(
            top: -30,
            left: 30,
            child: Transform.rotate(
              angle: 68 * 3.14159 / 180, // Convert degrees to radians
              alignment: Alignment.topLeft, // Rotate around the top-left corner
              child: Container(
                width: 280,
                height: 280,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -110,
            right: -110,
            child: Container(
              width: 350,
              height: 350,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Share your stories\nwith us',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 26),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the Signup screen when "Create your blog" is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupScreenView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'Create your blog',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sign In button
          Positioned(
            top: 50,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to Login screen when Sign In button is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreenView()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
