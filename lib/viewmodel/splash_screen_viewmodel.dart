import 'dart:async';
import 'package:flutter/material.dart';
import 'package:linkora_app/model/splash_screen_model.dart';
import 'package:linkora_app/view/onboarding_screen_view.dart'; // Import the model

class SplashScreenViewModel extends ChangeNotifier {
  final AppConfigModel appConfigModel;

  SplashScreenViewModel(this.appConfigModel);

  // Timer to navigate to onboarding screen after 3 seconds
  void navigateToOnboarding(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        _createPageRoute(),
      );
    });
  }

  // Custom PageRouteBuilder to add the animation
  PageRouteBuilder _createPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const OnboardingScreenView(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        );
        var scaleAnimation = Tween(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
    );
  }

  // Method to fetch app configuration
  Future<void> loadAppConfig() async {
    String config = await appConfigModel.fetchAppConfiguration();
    // You can update any state based on this config if needed
    print(config); // For demonstration
  }
}
