import 'package:dartz/dartz.dart';
import 'package:linkora_app/app/usecase/usecase.dart'; // Import UsecaseWithParams
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/repository/blog_repository.dart';

class GetUserWrittenBlogsUseCase
    implements UsecaseWithParams<List<BlogEntity>, Map<String, dynamic>> {
  final IBlogRepository repository;

  GetUserWrittenBlogsUseCase(this.repository);

  @override
  Future<Either<Failure, List<BlogEntity>>> call(
      Map<String, dynamic> params) async {
    final int page = params['page'];
    final bool draft = params['draft'];
    return await repository.getUserWrittenBlogs(page: page, draft: draft);
  }
}
