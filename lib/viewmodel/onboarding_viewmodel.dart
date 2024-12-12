import 'package:flutter/material.dart';
import 'package:linkora_app/model/onboarding_model.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;

  final List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      title: "Share your stories",
      description:
          "Create and share blogs with the community. Your voice matters!",
      icon: Icons.edit,
    ),
    OnboardingModel(
      title: "Engage and Connect",
      description: "Like, comment, and connect with creators worldwide.",
      icon: Icons.people,
    ),
    OnboardingModel(
      title: "Discover Content",
      description:
          "Explore amazing stories and perspectives tailored to your interests.",
      icon: Icons.search,
    ),
  ];

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (currentPage < onboardingPages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutExpo,
      );
    }
  }

  void disposeControllers() {
    pageController.dispose();
  }
}
