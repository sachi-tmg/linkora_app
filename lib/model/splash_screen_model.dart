import 'dart:async';

class AppConfigModel {
  Future<String> fetchAppConfiguration() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'App Config Data';
  }
}
