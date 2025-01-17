part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingPageChanged extends OnboardingState {
  final int currentIndex;

  const OnboardingPageChanged({required this.currentIndex});

  @override
  List<Object> get props => [currentIndex];
}
