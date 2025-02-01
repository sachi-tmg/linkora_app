import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:linkora_app/app/usecase/usecase.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/regular_user/domain/entity/regular_user_entity.dart';
import 'package:linkora_app/features/regular_user/domain/respository/regular_user_repository.dart';

class RegularUserUsecaseParams extends Equatable {
  final String userId;
  final String? profilePicture;
  final String? bio;

  const RegularUserUsecaseParams({
    required this.userId,
    this.profilePicture,
    this.bio,
  });

  const RegularUserUsecaseParams.initial({
    required this.userId,
    this.profilePicture,
    this.bio,
  });

  @override
  List<Object?> get props => [userId, profilePicture, bio];
}

class RegularUserUsecase
    implements UsecaseWithParams<void, RegularUserUsecaseParams> {
  final IRegularUserRepository repository;

  RegularUserUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(RegularUserUsecaseParams params) {
    final regularUserEntity = RegularUserEntity(
      userId: params.userId,
      profilePicture: params.profilePicture,
      bio: params.bio,
    );
    debugPrint("User ID in Usecase: ${params.userId}");
    return repository.regularUser(regularUserEntity);
  }
}

class UploadImageParamsP {
  final File file;

  const UploadImageParamsP({
    required this.file,
  });
}

class UploadImageUsecaseP
    implements UsecaseWithParams<String, UploadImageParamsP> {
  final IRegularUserRepository _repository;

  UploadImageUsecaseP(this._repository);

  @override
  Future<Either<Failure, String>> call(UploadImageParamsP params) {
    return _repository.uploadProfilePicture(params.file);
  }
}
