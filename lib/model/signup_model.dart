class SignupModel {
  String username;
  String email;
  String password;

  SignupModel({
    required this.username,
    required this.email,
    required this.password,
  });

  bool validate() {
    return username.isNotEmpty && email.isNotEmpty && password.isNotEmpty;
  }
}
