class SignupModel {
  String fullName;
  String email;
  String password;
  String confirmPassword;

  SignupModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  bool validate() {
    return fullName.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword; // Ensure passwords match
  }
}
