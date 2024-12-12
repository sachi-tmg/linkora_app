import 'package:flutter/material.dart';
import 'package:linkora_app/view/login_screen_view.dart';
import 'package:linkora_app/model/signup_model.dart';

class SignupViewModel extends ChangeNotifier {
  final SignupModel _model = SignupModel(username: '', email: '', password: '');

  String get username => _model.username;
  String get email => _model.email;
  String get password => _model.password;

  void updateUsername(String value) {
    _model.username = value;
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

  bool validateFields() {
    return _model.validate();
  }

  void signUp(BuildContext context) {
    if (validateFields()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreenView()),
      );
    } else {
      print("All fields must be filled.");
    }
  }
}
