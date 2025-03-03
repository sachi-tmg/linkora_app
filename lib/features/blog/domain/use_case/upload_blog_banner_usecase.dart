import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:linkora_app/app/usecase/usecase.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/domain/repository/blog_repository.dart';

class UploadBlogBannerParams {
  final File file;

  const UploadBlogBannerParams({
    required this.file,
  });
}

class UploadBlogBannerUsecase
    implements UsecaseWithParams<String, UploadBlogBannerParams> {
  final IBlogRepository _repository;

  UploadBlogBannerUsecase(this._repository);

  @override
  Future<Either<Failure, String>> call(UploadBlogBannerParams params) {
    return _repository.uploadBlogPicture(params.file);
  }
}
