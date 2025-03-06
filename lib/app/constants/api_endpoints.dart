class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String baseUrl = "http://192.168.1.3:3000/";

  // Auth Routes
  static const String login = "api/user/login";
  static const String register = "api/user/registerUser";

  // Profile Routes
  static const String getRegularUser = "api/regular-users/get-profile";
  static const String uploadImage = "api/regular-users/uploadImage";
  static const String updateRegularUser = "api/regular-users/save";

  //blog routes
  static const String createBlogs = "api/blog/create-blog";
  static const String uploadBanner = "api/blog/uploadBanner";
  static const String latestBlogs = "api/blog/latest-blogs";
  static const String viewFullBlog = "api/blog/blog-view";
  static const String searchBlogs = "api/blog/search-blogs";
  static const String getUserWrittenBlogs = "api/blog/user-written-blogs";
  static const String deleteBlog = "api/blog/delete-blog";
  static const String likeBlog = "api/blog/like-blog";
}
