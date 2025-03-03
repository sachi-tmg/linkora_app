// lib/features/blog/domain/repositories/blog_repository.dart
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/data/model/blog_api_model.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';

abstract class IBlogRepository {
  Future<Either<Failure, List<BlogEntity>>> getLatestBlogs(int page);

  Future<Either<Failure, String>> createBlog(BlogApiModel blog);

  Future<Either<Failure, String>> uploadBlogPicture(File file);
}
