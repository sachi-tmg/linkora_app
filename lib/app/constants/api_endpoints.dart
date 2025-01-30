class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String baseUrl = "http://10.0.2.2:3000/";

  // Auth Routes
  static const String login = "user/login";
  static const String register = "user/registerUser";
  static const String uploadImage = "user/uploadImage";
}
