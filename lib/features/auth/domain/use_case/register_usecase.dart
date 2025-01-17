import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:linkora_app/app/usecase/usecase.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/auth/domain/entity/auth_entity.dart';
import 'package:linkora_app/features/auth/domain/repository/auth_repository.dart';

class RegisterUserParams extends Equatable {
  final String fullName;
  final String email;
  final String password;

  const RegisterUserParams({
    required this.fullName,
    required this.email,
    required this.password,
  });

  const RegisterUserParams.initial({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, password];
}

class RegisterUseCase implements UsecaseWithParams<void, RegisterUserParams> {
  final IAuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final authEntity = AuthEntity(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
    );
    return repository.registerUser(authEntity);
  }
}
