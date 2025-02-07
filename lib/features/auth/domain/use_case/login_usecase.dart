// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:linkora_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:linkora_app/app/usecase/usecase.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/auth/domain/repository/auth_repository.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  // Initial Constructor
  const LoginParams.initial()
      : email = '',
        password = '';

  @override
  List<Object> get props => [email, password];
}

class LoginUseCase implements UsecaseWithParams<String, LoginParams> {
  final IAuthRepository repository;
  final TokenSharedPrefs tokenSharedPrefs;

  LoginUseCase(this.repository, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, String>> call(LoginParams params) {
    return repository.loginUser(params.email, params.password).then((value) {
      return value.fold(
        (failure) => Left(failure),
        (token) async {
          try {
            await tokenSharedPrefs.saveToken(token);
            await tokenSharedPrefs.getToken();
            // final jwt = JWT.decode(token);
            // final payload = jwt.payload as Map<String, dynamic>;
            // final userId = payload['userId'] ?? payload['_id'];

            // await tokenSharedPrefs.sharedPreferences.setString('id', userId);

            return Right(token);
          } catch (e) {
            return Left(
                SharedPrefsFailure(message: 'Failed to decode JWT token: $e'));
          }
        },
      );
    });
  }
}
