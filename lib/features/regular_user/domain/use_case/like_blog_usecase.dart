import 'package:dartz/dartz.dart';
import 'package:linkora_app/app/usecase/usecase.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/domain/repository/blog_repository.dart';

class LikeBlogUseCase implements UsecaseWithParams<bool, LikeBlogParams> {
  final IBlogRepository repository;

  LikeBlogUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(LikeBlogParams params) {
    return repository.likeBlog(params.id, params.isLikedByUser);
  }
}

class LikeBlogParams {
  final String id;
  final bool isLikedByUser;

  LikeBlogParams({required this.id, required this.isLikedByUser});
}
