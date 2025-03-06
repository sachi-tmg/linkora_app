import 'dart:io';

import 'package:linkora_app/core/network/hive_service.dart';
import 'package:linkora_app/features/blog/data/data_source/blog_data_source.dart';
import 'package:linkora_app/features/blog/data/model/blog_api_model.dart';
import 'package:linkora_app/features/blog/data/model/blog_hive_model.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';

class BlogLocalDataSource implements IBlogDataSource {
  final HiveService _blogHiveService;

  BlogLocalDataSource(this._blogHiveService);

  @override
  Future<List<BlogEntity>> getLatestBlogs(int page) async {
    try {
      List<BlogHiveModel> blogs = await _blogHiveService.getAllBlogs();
      return blogs.map((blog) => blog.toEntity()).toList();
    } catch (e) {
      throw Exception("Error fetching latest blogs from local storage: $e");
    }
  }

  @override
  Future<String> createBlog(BlogApiModel blog) async {
    try {
      final blogHiveModel = BlogHiveModel.fromEntity(blog.toEntity());
      await _blogHiveService.saveBlog(blogHiveModel);
      return blogHiveModel.blogId ?? '';
    } catch (e) {
      throw Exception("Error creating blog in local storage: $e");
    }
  }

  @override
  Future<String> uploadBlogPicture(File file) async {
    return 'some_image_url';
  }

  @override
  Future<BlogApiModel> getBlog(String blogId) async {
    try {
      BlogHiveModel? blog = await _blogHiveService.getBlogById(blogId);
      if (blog != null) {
        return BlogApiModel.fromEntity(blog.toEntity());
      } else {
        throw Exception("Blog not found in local storage");
      }
    } catch (e) {
      throw Exception("Error fetching blog from local storage: $e");
    }
  }

  @override
  Future<List<BlogEntity>> searchBlogs(String query, {int page = 1}) async {
    try {
      List<BlogHiveModel> blogs = await _blogHiveService.getAllBlogs();
      List<BlogHiveModel> filteredBlogs = blogs
          .where((blog) =>
              blog.title.contains(query) || blog.description.contains(query))
          .toList();
      return filteredBlogs.map((blog) => blog.toEntity()).toList();
    } catch (e) {
      throw Exception("Error searching blogs in local storage: $e");
    }
  }

  @override
  Future<List<BlogEntity>> getUserWrittenBlogs(
      {int page = 1, bool draft = false}) async {
    try {
      List<BlogHiveModel> blogs = await _blogHiveService.getAllBlogs();
      List<BlogHiveModel> filteredBlogs =
          blogs.where((blog) => (blog.draft == draft)).toList();
      return filteredBlogs.map((blog) => blog.toEntity()).toList();
    } catch (e) {
      throw Exception(
          "Error fetching user-written blogs from local storage: $e");
    }
  }

  @override
  Future<void> deleteBlog(String blogId) async {
    try {
      await _blogHiveService.deleteBlog(blogId);
    } catch (e) {
      throw Exception("Error deleting blog from local storage: $e");
    }
  }

  @override
  Future<bool> likeBlog(String id, bool isLikedByUser) async {
    try {
      final blogHiveModel = await _blogHiveService.getBlogById(id);
      if (blogHiveModel != null) {
        final updatedBlogHiveModel = BlogHiveModel(
          id: blogHiveModel.id,
          blogId: blogHiveModel.blogId,
          title: blogHiveModel.title,
          description: blogHiveModel.description,
          blogPicture: blogHiveModel.blogPicture,
          content: blogHiveModel.content,
          draft: blogHiveModel.draft,
          activity: blogHiveModel.activity,
          tags: blogHiveModel.tags,
          dateCreated: blogHiveModel.dateCreated,
          user: blogHiveModel.user,
          profilePicture: blogHiveModel.profilePicture,
        );
        await _blogHiveService.saveBlog(updatedBlogHiveModel);
        return true; // Assuming like operation succeeded
      }
      return false; // Blog not found
    } catch (e) {
      throw Exception("Error liking blog in local storage: $e");
    }
  }
}
