import 'package:flutter/material.dart';
import 'package:linkora_app/core/app_theme/app_theme.dart';
import 'package:linkora_app/view/splash_screen_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: const SplashScreenView(),
    );
  }
}
