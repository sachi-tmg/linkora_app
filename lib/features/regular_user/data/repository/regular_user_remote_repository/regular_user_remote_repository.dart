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
  Future<Either<Failure, RegularUserEntity>> getRegularUser(
      String username) async {
    try {
      final regularUser =
          await _regularUserRemoteDataSource.getRegularUser(username);
      return Right(regularUser);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateRegularUser(
      RegularUserEntity regularUser) async {
    try {
      await _regularUserRemoteDataSource.updateRegularUser(regularUser);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
