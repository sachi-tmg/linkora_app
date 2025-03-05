import 'dart:io';

import 'package:linkora_app/features/blog/data/model/blog_api_model.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';

abstract class IBlogDataSource {
  // Fetches the latest blogs with pagination
  Future<List<BlogEntity>> getLatestBlogs(int page);

  //creating blogs
  Future<String> createBlog(BlogApiModel blog);

  //uploading Banner
  Future<String> uploadBlogPicture(File file);

  Future<BlogApiModel> getBlog(String blogId);

  Future<List<BlogEntity>> searchBlogs(String query, {int page = 1});

  Future<List<BlogEntity>> getUserWrittenBlogs(
      {int page = 1, bool draft = false});
}
