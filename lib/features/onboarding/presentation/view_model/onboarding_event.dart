part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class OnboardingPageChangeEvent extends OnboardingEvent {
  final int currentIndex;

  const OnboardingPageChangeEvent({required this.currentIndex});

  @override
  List<Object> get props => [currentIndex];
}

class NavigateToScreenEvent extends OnboardingEvent {
  final BuildContext context;
  final Widget destination;

  const NavigateToScreenEvent({
    required this.context,
    required this.destination,
  });

  @override
  List<Object> get props => [context, destination];
}
