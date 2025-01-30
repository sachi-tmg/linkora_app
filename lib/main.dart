import 'package:flutter/material.dart';
import 'package:linkora_app/app/app.dart';
import 'package:linkora_app/app/di/di.dart';
import 'package:linkora_app/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive Database
  await HiveService.init();

  // Initialize dependencies
  await initDependencies();

  runApp(
    const App(),
  );
}
