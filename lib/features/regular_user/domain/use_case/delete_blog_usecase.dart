import 'package:dartz/dartz.dart';
import 'package:linkora_app/app/usecase/usecase.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/domain/repository/blog_repository.dart';

class DeleteBlogUseCase implements UsecaseWithParams<String, String> {
  final IBlogRepository repository;

  DeleteBlogUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(String blogId) async {
    return repository.deleteBlog(blogId);
  }
}
