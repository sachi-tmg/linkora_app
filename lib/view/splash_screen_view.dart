import 'package:flutter/material.dart';
import 'package:linkora_app/model/splash_screen_model.dart';
import 'package:linkora_app/viewmodel/splash_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashScreenViewModel(AppConfigModel()),
      child: Consumer<SplashScreenViewModel>(
        builder: (context, viewModel, child) {
          viewModel.navigateToOnboarding(context);
          viewModel.loadAppConfig();

          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
              ),
            ),
          );
        },
      ),
    );
  }
}
