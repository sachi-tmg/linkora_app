import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/regular_user/domain/entity/regular_user_entity.dart';

abstract interface class IRegularUserRepository {
  Future<Either<Failure, void>> regularUser(RegularUserEntity ruser);

  Future<Either<Failure, String>> uploadProfilePicture(File file);
}
