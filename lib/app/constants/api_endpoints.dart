class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String baseUrl = "http://10.0.2.2:3000/api/";

  // Auth Routes
  static const String login = "user/login";
  static const String register = "user/registerUser";

  // Profile Routes
  static const String createRegularUser = "regular-users/save";
  static const String uploadImage = "regular-users/uploadImage";
}
