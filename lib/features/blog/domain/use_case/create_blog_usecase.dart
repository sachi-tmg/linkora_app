import 'package:dartz/dartz.dart';
import 'package:linkora_app/app/usecase/usecase.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/data/model/blog_api_model.dart';
import 'package:linkora_app/features/blog/domain/repository/blog_repository.dart';

class CreateBlogUseCase implements UsecaseWithParams<String, BlogApiModel> {
  final IBlogRepository repository;

  CreateBlogUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(BlogApiModel blog) async {
    return await repository.createBlog(blog);
  }
}
