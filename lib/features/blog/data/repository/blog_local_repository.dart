import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/core/network/hive_service.dart';
import 'package:linkora_app/features/blog/data/model/blog_api_model.dart';
import 'package:linkora_app/features/blog/data/model/blog_hive_model.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/repository/blog_repository.dart';

class BlogLocalRepository implements IBlogRepository {
  final HiveService _hiveService;

  BlogLocalRepository(this._hiveService);

  @override
  Future<Either<Failure, List<BlogEntity>>> getLatestBlogs(int page) async {
    try {
      final blogsHive = await _hiveService.getBlogsPaginated(page: page);
      final List<BlogEntity> blogs =
          blogsHive.map((blog) => blog.toEntity()).toList();
      return Right(blogs);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createBlog(BlogApiModel blog) async {
    try {
      final blogHiveModel = BlogHiveModel.fromEntity(blog.toEntity());
      await _hiveService.saveBlog(blogHiveModel);
      return Right(blogHiveModel.blogId!);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadBlogPicture(File file) async {
    return const Left(LocalDatabaseFailure(
        message: "Upload functionality should be handled remotely"));
  }

  @override
  Future<Either<Failure, BlogEntity>> getBlog(String blogId) async {
    try {
      final blogHive = await _hiveService.getBlogById(blogId);
      if (blogHive != null) {
        return Right(blogHive.toEntity());
      } else {
        return const Left(LocalDatabaseFailure(message: "Blog not found"));
      }
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BlogEntity>>> searchBlogs(String query,
      {int page = 1}) async {
    try {
      final blogsHive = await _hiveService.getBlogsPaginated(page: page);
      final List<BlogEntity> blogs = blogsHive
          .where((blog) =>
              blog.title.contains(query) || blog.description.contains(query))
          .map((blog) => blog.toEntity())
          .toList();
      return Right(blogs);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BlogEntity>>> getUserWrittenBlogs(
      {int page = 1, bool draft = false}) async {
    try {
      final blogsHive = await _hiveService.getBlogsPaginated(page: page);
      final List<BlogEntity> blogs = blogsHive
          .where((blog) => blog.draft == draft)
          .map((blog) => blog.toEntity())
          .toList();
      return Right(blogs);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteBlog(String blogId) async {
    try {
      await _hiveService.deleteBlog(blogId);
      return const Right("Blog deleted successfully");
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> likeBlog(String id, bool isLikedByUser) async {
    try {
      final blogHiveModel = await _hiveService.getBlogById(id);
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
        await _hiveService.saveBlog(updatedBlogHiveModel);
        return const Right(true); // Assuming like operation succeeded
      }
      return const Left(LocalDatabaseFailure(message: "Blog not found"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
