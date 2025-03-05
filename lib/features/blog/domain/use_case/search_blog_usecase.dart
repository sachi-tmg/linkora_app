import 'package:dartz/dartz.dart';
import 'package:linkora_app/app/usecase/usecase.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/repository/blog_repository.dart';

class SearchBlogsUseCase
    implements UsecaseWithParams<List<BlogEntity>, String> {
  final IBlogRepository blogRepository;

  SearchBlogsUseCase(this.blogRepository);

  @override
  Future<Either<Failure, List<BlogEntity>>> call(String query,
      {int page = 1}) async {
    return await blogRepository.searchBlogs(query, page: page);
  }
}
