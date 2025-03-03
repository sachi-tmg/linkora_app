import 'package:dio/dio.dart';
import 'package:linkora_app/app/constants/api_endpoints.dart';
import 'package:linkora_app/features/blog/data/data_source/blog_data_source.dart';
import 'package:linkora_app/features/blog/data/model/blog_api_model.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';

class BlogRemoteDataSource implements IBlogDataSource {
  final Dio _dio;

  BlogRemoteDataSource({
    required Dio dio,
  }) : _dio = dio;

  @override
  Future<List<BlogEntity>> getLatestBlogs(int page) async {
    try {
      print("Fetching latest blogs...");
      var response = await _dio.post(
        ApiEndpoints.latestBlogs, // Use the correct endpoint
        data: {"page": page}, // Pass the page number in the request body
      );
      print("Raw Response: ${response.data}");

      if (response.statusCode == 200) {
        // Parse the response
        final List<dynamic> blogsJson = response.data['blogs'];
        final List<BlogEntity> blogs = blogsJson
            .map((blogJson) => BlogApiModel.fromJson(blogJson).toEntity())
            .toList();
        return blogs;
      } else {
        print("Error: ${response.statusMessage}");
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      throw Exception(e);
    } catch (e) {
      print("Other Exception: $e");
      throw Exception(e);
    }
  }
}
