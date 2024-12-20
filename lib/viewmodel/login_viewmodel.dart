import 'package:flutter/material.dart';
import 'package:linkora_app/core/common/bottom_navigation_bar.dart';
import 'package:linkora_app/model/login_model.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginModel _loginModel = LoginModel(email: '', password: '');

  LoginModel get loginModel => _loginModel;

  void updateEmail(String value) {
    _loginModel.email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    _loginModel.password = value;
    notifyListeners();
  }

  // Validation method
  bool validateFields(BuildContext context) {
    if (_loginModel.email.isEmpty || _loginModel.password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the fields."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Validate email format
    if (!_loginModel.email.contains('@') ||
        !_loginModel.email.endsWith('.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Please enter a valid email (e.g. example@domain.com)."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Check if password is not empty
    if (_loginModel.password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your password."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  // Handle login action
  void login(BuildContext context) {
    if (validateFields(context)) {
      // Assuming successful login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login successful!"),
          backgroundColor: Colors.green,
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      });
    }
  }
}
