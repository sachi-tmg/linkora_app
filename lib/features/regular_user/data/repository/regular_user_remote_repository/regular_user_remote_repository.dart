import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/regular_user/data/data_source/remote_datasource/regular_user_remote_data_source.dart';
import 'package:linkora_app/features/regular_user/domain/entity/regular_user_entity.dart';
import 'package:linkora_app/features/regular_user/domain/respository/regular_user_repository.dart';

class RegularUserRemoteRepository implements IRegularUserRepository {
  final RegularUserRemoteDataSource _regularUserRemoteDataSource;

  RegularUserRemoteRepository(this._regularUserRemoteDataSource);

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final imageName =
          await _regularUserRemoteDataSource.uploadProfilePicture(file);
      return Right(imageName);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> regularUser(RegularUserEntity ruser) async {
    try {
      await _regularUserRemoteDataSource.regularUser(ruser);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
