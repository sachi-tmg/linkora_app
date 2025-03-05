class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String baseUrl = "http://192.168.1.3:3000/api/";

  // Auth Routes
  static const String login = "user/login";
  static const String register = "user/registerUser";

  // Profile Routes
  static const String getRegularUser = "regular-users/get-profile";
  static const String uploadImage = "regular-users/uploadImage";
  static const String updateRegularUser = "regular-users/save";

  //blog routes
  static const String createBlogs = "blog/create-blog";
  static const String uploadBanner = "blog/uploadBanner";
  static const String latestBlogs = "blog/latest-blogs";
  static const String viewFullBlog = "blog/blog-view";
  static const String searchBlogs = "blog/search-blogs";
  static const String getUserWrittenBlogs = "blog//user-written-blogs";
}
