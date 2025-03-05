import 'dart:io';

import 'package:dio/dio.dart';
import 'package:linkora_app/app/constants/api_endpoints.dart';
import 'package:linkora_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:linkora_app/features/blog/data/data_source/blog_data_source.dart';
import 'package:linkora_app/features/blog/data/model/blog_api_model.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';

class BlogRemoteDataSource implements IBlogDataSource {
  final Dio _dio;
  final TokenSharedPrefs _tokenSharedPrefs;

  BlogRemoteDataSource({
    required Dio dio,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _dio = dio,
        _tokenSharedPrefs = tokenSharedPrefs;

  Future<String?> _getToken() async {
    final tokenResult = await _tokenSharedPrefs.getToken();
    return tokenResult.getOrElse(() => '');
  }

  @override
  Future<List<BlogEntity>> getLatestBlogs(int page) async {
    try {
      var response = await _dio.post(
        ApiEndpoints.latestBlogs,
        data: {"page": page},
      );

      if (response.statusCode == 200) {
        // Parse the response
        final List<dynamic> blogsJson = response.data['blogs'];
        final List<BlogEntity> blogs = blogsJson
            .map((blogJson) => BlogApiModel.fromJson(blogJson).toEntity())
            .toList();
        return blogs;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> createBlog(BlogApiModel blog) async {
    try {
      final token = await _getToken();
      final response = await _dio.post(
        ApiEndpoints.createBlogs,
        data: blog.toJson(),
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : {},
        ),
      );

      if (response.statusCode == 200) {
        return response.data['id'];
      } else {
        throw Exception("Failed to create blog: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.message}");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  @override
  Future<String> uploadBlogPicture(File file) async {
    try {
      String fileName = file.path;
      FormData formData = FormData.fromMap(
        {
          'blogBanner': await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        },
      );

      Response response = await _dio.post(
        ApiEndpoints.uploadBanner,
        data: formData,
      );

      if (response.statusCode == 200) {
        final imageName = response.data['filename'];
        return imageName;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<BlogApiModel> getBlog(String blogId) async {
    try {
      print("Fetching blog with ID in remote datasource: $blogId");
      final response = await _dio.post(
        ApiEndpoints.viewFullBlog,
        data: {"blog_id": blogId},
      );

      print("API Response in remote datasource: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = response.data['blog'];
        return BlogApiModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: "Failed to fetch blog: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.viewFullBlog),
        error: e.message,
      );
    } catch (e) {
      print("Unexpected error in remote datasource: $e");
      throw Exception("Unexpected error: $e");
    }
  }

  Future<List<BlogEntity>> searchBlogs(String query, {int page = 1}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.searchBlogs,
        data: {"query": query, "page": page},
      );

      if (response.statusCode == 200) {
        final List<dynamic> blogsJson = response.data['blogs'];
        final List<BlogEntity> blogs = blogsJson
            .map((blogJson) => BlogApiModel.fromJson(blogJson).toEntity())
            .toList();
        return blogs;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }
}
