import 'package:hive_flutter/hive_flutter.dart';
import 'package:linkora_app/app/constants/hive_table_constant.dart';
import 'package:linkora_app/features/auth/data/model/auth_hive_model.dart';
import 'package:linkora_app/features/blog/data/model/blog_hive_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static Future<void> init() async {
    // Initialize the database
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}linkora_app.db';

    Hive.init(path);

    // Register Adapter
    Hive.registerAdapter(AuthHiveModelAdapter());
    Hive.registerAdapter(BlogHiveModelAdapter());
  }

  // Auth Queries
  Future<void> register(AuthHiveModel auth) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.put(auth.userId, auth);
  }

  Future<void> deleteAuth(String id) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.delete(id);
  }

  Future<List<AuthHiveModel>> getAllAuth() async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    return box.values.toList();
  }

  // Login using email and password
  Future<AuthHiveModel?> login(String email, String password) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    var user = box.values.firstWhere(
        (element) => element.email == email && element.password == password);
    box.close();
    return user;
  }

  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  // Clear User Box
  Future<void> clearUserBox() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  // Save a blog to Hive
  Future<void> saveBlog(BlogHiveModel blog) async {
    var box = await Hive.openBox<BlogHiveModel>(HiveTableConstant.blogBox);
    await box.put(blog.blogId, blog);
  }

  // Delete a blog by its ID
  Future<void> deleteBlog(String blogId) async {
    var box = await Hive.openBox<BlogHiveModel>(HiveTableConstant.blogBox);
    await box.delete(blogId);
  }

  // Fetch a single blog by its ID
  Future<BlogHiveModel?> getBlogById(String blogId) async {
    var box = await Hive.openBox<BlogHiveModel>(HiveTableConstant.blogBox);
    return box.get(blogId);
  }

  // Fetch all blogs
  Future<List<BlogHiveModel>> getAllBlogs() async {
    var box = await Hive.openBox<BlogHiveModel>(HiveTableConstant.blogBox);
    return box.values.toList();
  }

  // Fetch a list of blogs with pagination (can add filters in the future)
  Future<List<BlogHiveModel>> getBlogsPaginated(
      {int page = 1, int pageSize = 10}) async {
    var box = await Hive.openBox<BlogHiveModel>(HiveTableConstant.blogBox);
    final blogs = box.values.toList();
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    return blogs.sublist(
      startIndex,
      endIndex > blogs.length ? blogs.length : endIndex,
    ); // Return the subset based on pagination
  }

  // Update a blog (save again if it exists)
  Future<void> updateBlog(BlogHiveModel blog) async {
    var box = await Hive.openBox<BlogHiveModel>(HiveTableConstant.blogBox);
    await box.put(blog.blogId, blog);
  }

  // Clear all blogs from Hive (deletes the entire box)
  Future<void> clearBlogBox() async {
    var box = await Hive.openBox<BlogHiveModel>(HiveTableConstant.blogBox);
    await box.clear();
  }

  // Check if the blog box is open
  Future<bool> isBlogBoxOpen() async {
    var box = await Hive.openBox<BlogHiveModel>(HiveTableConstant.blogBox);
    return box.isOpen;
  }

  // Close the Hive box (used when no longer needed)
  Future<void> close() async {
    await Hive.close();
  }
}
