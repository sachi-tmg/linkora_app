// lib/features/blog/domain/repositories/blog_repository.dart
import 'package:dartz/dartz.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';

abstract class BlogRepository {
  Future<Either<Failure, List<BlogEntity>>> getLatestBlogs(int page);
}
