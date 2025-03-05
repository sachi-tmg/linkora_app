import 'package:dartz/dartz.dart';
import 'package:linkora_app/app/usecase/usecase.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/repository/blog_repository.dart';

class GetBlogUseCase implements UsecaseWithParams<BlogEntity, String> {
  final IBlogRepository repository;

  GetBlogUseCase(this.repository);

  @override
  Future<Either<Failure, BlogEntity>> call(String blogId) {
    print("Fetching blog in use case with ID: $blogId");
    return repository.getBlog(blogId);
  }
}
