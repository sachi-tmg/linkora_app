import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linkora_app/app/di/di.dart';
import 'package:linkora_app/features/auth/presentation/view/register_view.dart';
import 'package:linkora_app/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:linkora_app/features/onboarding/presentation/view_model/onboarding_bloc.dart';

class OnboardingView extends StatelessWidget {
  OnboardingView({super.key});

  final PageController _pageController = PageController();
  final List<Map<String, dynamic>> _onboardingData = [
    {
      'svgPath': 'assets/icons/welcome.svg',
      'title': "Welcome to Linkora!",
      'description':
          "Start your journey with Linkora, where you can share your thoughts and ideas.",
    },
    {
      'svgPath': 'assets/icons/explore.svg',
      'title': "Discover what you like!",
      'description': "Browse blogs and find topics that interest you most.",
    },
    {
      'svgPath': 'assets/icons/start.svg',
      'title': "Let's get started!",
      'description': "Get ready to write, share, and enjoy the experience.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: BlocBuilder<OnboardingBloc, OnboardingState>(
                    builder: (context, state) {
                      return PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          context.read<OnboardingBloc>().add(
                                OnboardingPageChangeEvent(currentIndex: index),
                              );
                        },
                        itemCount: _onboardingData.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                _onboardingData[index]['svgPath'],
                                height: 200,
                                width: 200,
                              ),
                              const SizedBox(height: 40),
                              Text(
                                _onboardingData[index]['title'],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _onboardingData[index]['description'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                Column(
                  children: [
                    BlocBuilder<OnboardingBloc, OnboardingState>(
                      builder: (context, state) {
                        final currentPage = state is OnboardingPageChanged
                            ? state.currentIndex
                            : 0;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _onboardingData.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              height: 10,
                              width: currentPage == index ? 20 : 10,
                              decoration: BoxDecoration(
                                color: currentPage == index
                                    ? const Color.fromARGB(255, 26, 39, 49)
                                    : Colors.grey[400],
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<OnboardingBloc, OnboardingState>(
                      builder: (context, state) {
                        final isLastPage = state is OnboardingPageChanged &&
                            state.currentIndex == _onboardingData.length - 1;

                        return ElevatedButton(
                          onPressed: () {
                            if (isLastPage) {
                              // Navigate to RegisterView and provide RegisterBloc here
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return BlocProvider<RegisterBloc>(
                                      create: (_) => getIt<RegisterBloc>(),
                                      child: RegisterView(),
                                    );
                                  },
                                ),
                              );
                            } else {
                              // Move to the next page
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Text(
                            isLastPage ? 'Get Started' : 'Next',
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                  ],
                ),
              ],
            ),
            BlocBuilder<OnboardingBloc, OnboardingState>(
              builder: (context, state) {
                final currentPage =
                    state is OnboardingPageChanged ? state.currentIndex : 0;

                return currentPage == _onboardingData.length - 1
                    ? const SizedBox()
                    : Positioned(
                        top: 10,
                        right: 10,
                        child: TextButton(
                          onPressed: () {
                            // Navigate directly to the last page
                            _pageController.jumpToPage(
                              _onboardingData.length - 1,
                            );
                          },
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
