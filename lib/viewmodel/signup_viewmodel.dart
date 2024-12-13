import 'package:flutter/material.dart';
import 'package:linkora_app/view/dashboard_screen_view.dart';
import 'package:linkora_app/model/signup_model.dart';

class SignupViewModel extends ChangeNotifier {
  final SignupModel _model = SignupModel(
    fullName: '',
    email: '',
    password: '',
    confirmPassword: '',
  );

  String get fullName => _model.fullName;
  String get email => _model.email;
  String get password => _model.password;
  String get confirmPassword => _model.confirmPassword;

  void updateFullName(String value) {
    _model.fullName = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    _model.email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    _model.password = value;
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    _model.confirmPassword = value;
    notifyListeners();
  }

  bool validateFields(BuildContext context) {
    // Check if fields are empty
    if (_model.fullName.isEmpty ||
        _model.email.isEmpty ||
        _model.password.isEmpty ||
        _model.confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the fields."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Validate email format
    if (!_model.email.contains('@') || !_model.email.endsWith('.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Please enter a valid email (e.g. example@domain.com)."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Validate password length
    if (_model.password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must be at least 8 characters long."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Check if passwords match
    if (_model.password != _model.confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords must match."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  void signUp(BuildContext context) {
    if (validateFields(context)) {
      // Clear text fields after successful validation
      _model.fullName = '';
      _model.email = '';
      _model.password = '';
      _model.confirmPassword = '';
      notifyListeners();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User successfully registered!"),
          backgroundColor: Colors.green,
        ),
      );

      // Delay the navigation to the Dashboard screen
      Future.delayed(const Duration(seconds: 2), () {
        // Navigate to the Dashboard screen
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreenView()),
        );
      });
    }
  }
}
