import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:linkora_app/features/onboarding/presentation/view_model/onboarding_bloc.dart';

class SplashCubit extends Cubit<void> {
  SplashCubit(this._onboardingBloc) : super(null);

  final OnboardingBloc _onboardingBloc;

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2), () async {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: _onboardingBloc,
              child: OnboardingView(),
            ),
          ),
        );
      }
    });
  }
}
