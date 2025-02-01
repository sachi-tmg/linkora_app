import 'package:dartz/dartz.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/auth/domain/entity/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, void>> registerUser(AuthEntity user);

  Future<Either<Failure, String>> loginUser(String email, String password);

  Future<Either<Failure, AuthEntity>> getCurrentUser();
}
