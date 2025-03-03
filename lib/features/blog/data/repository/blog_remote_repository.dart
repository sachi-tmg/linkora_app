import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:linkora_app/app/constants/api_endpoints.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/data/model/blog_api_model.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/repository/blog_repository.dart';

class BlogRepositoryImpl implements BlogRepository {
  final Dio dioClient;

  BlogRepositoryImpl(this.dioClient);

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
}
