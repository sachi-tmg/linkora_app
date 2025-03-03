import 'package:dartz/dartz.dart';
import 'package:linkora_app/app/usecase/usecase.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/repository/blog_repository.dart';

class GetLatestBlogsUseCase
    implements UsecaseWithParams<List<BlogEntity>, int> {
  final BlogRepository repository;

  GetLatestBlogsUseCase(this.repository);

  @override
  Future<Either<Failure, List<BlogEntity>>> call(int page) async {
    return await repository.getLatestBlogs(page);
  }
}
