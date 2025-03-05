import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:linkora_app/app/constants/api_endpoints.dart';
import 'package:linkora_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/data/data_source/remote_datasource/blog_remote_data_source.dart';
import 'package:linkora_app/features/blog/data/model/blog_api_model.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/repository/blog_repository.dart';

class BlogRemoteRepository implements IBlogRepository {
  final Dio dioClient;
  final TokenSharedPrefs tokenSharedPrefs;
  final BlogRemoteDataSource _remoteDataSource;

  BlogRemoteRepository(
      this.dioClient, this.tokenSharedPrefs, this._remoteDataSource);

  Future<String?> _getToken() async {
    final tokenResult = await tokenSharedPrefs.getToken();
    return tokenResult.getOrElse(() => ''); // Get the token
  }

  @override
  Future<Either<Failure, List<BlogEntity>>> getLatestBlogs(int page) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.latestBlogs,
        data: {"page": page},
      );

      if (response.statusCode == 200) {
        final List<dynamic> blogsJson = response.data['blogs'];
        final List<BlogEntity> blogs = blogsJson
            .map((blogJson) => BlogApiModel.fromJson(blogJson).toEntity())
            .toList();
        return Right(blogs);
      } else {
        return const Left(ApiFailure(message: "Failed to fetch blogs"));
      }
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createBlog(BlogApiModel blog) async {
    try {
      final token = await _getToken();
      final response = await dioClient.post(
        ApiEndpoints.createBlogs,
        data: blog.toJson(),
        options: Options(
          headers: token != null
              ? {'Authorization': 'Bearer $token'}
              : {}, // Include the token
        ),
      );

      if (response.statusCode == 200) {
        return Right(response.data['id']);
      } else {
        return const Left(ApiFailure(message: "Failed to create blog"));
      }
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadBlogPicture(File file) async {
    try {
      final imageName = await _remoteDataSource.uploadBlogPicture(file);
      return Right(imageName);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BlogEntity>> getBlog(String blogId) async {
    try {
      print("Fetching blog in repository with ID: $blogId");
      final blog = await _remoteDataSource.getBlog(blogId);
      print("Blog fetched successfully: ${blog.toEntity()}");
      return Right(blog.toEntity());
    } catch (e) {
      print("Error fetching blog: $e");
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
