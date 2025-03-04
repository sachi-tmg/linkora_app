import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:linkora_app/app/usecase/usecase.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/regular_user/domain/respository/regular_user_repository.dart';

class UploadProfileParams {
  final File file;

  const UploadProfileParams({
    required this.file,
  });
}

class UploadProfilePictureUsecase
    implements UsecaseWithParams<String, UploadProfileParams> {
  final IRegularUserRepository _repository;

  UploadProfilePictureUsecase(this._repository);

  @override
  Future<Either<Failure, String>> call(UploadProfileParams params) {
    return _repository.uploadProfilePicture(params.file);
  }
}
