import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:linkora_app/app/constants/api_endpoints.dart';
import 'package:linkora_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/data/model/blog_api_model.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/repository/blog_repository.dart';

class BlogRepositoryImpl implements IBlogRepository {
  final Dio dioClient;
  final TokenSharedPrefs tokenSharedPrefs; // Added to access token prefs

  BlogRepositoryImpl(this.dioClient, this.tokenSharedPrefs);

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
      // Get the token
      FormData formData = FormData.fromMap({
        'blogBanner': await MultipartFile.fromFile(file.path),
      });

      final response = await dioClient.post(
        ApiEndpoints.uploadBanner,
        data: formData,
      );
      if (response.statusCode == 200) {
        final imageName =
            response.data['filename']; // Match backend response key
        return Right(imageName);
      } else {
        return const Left(ApiFailure(message: "Failed to upload image"));
      }
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
