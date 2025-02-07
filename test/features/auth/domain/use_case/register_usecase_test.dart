import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/auth/domain/entity/auth_entity.dart';
import 'package:linkora_app/features/auth/domain/use_case/register_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'repository.mock.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late RegisterUseCase usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = RegisterUseCase(mockAuthRepository);
    registerFallbackValue(const AuthEntity(
      fullName: 'Sachi Tamang',
      email: 'sachi@gmail.com',
      password: 'sachi123',
    ));
  });

  const registerParams = RegisterUserParams(
    fullName: 'Sachi Tamang',
    email: 'sachi@gmail.com',
    password: 'sachi123',
  );

  group('Register Tests', () {
    test('should return Failure when email is already in use', () async {
      // Arrange
      when(() => mockAuthRepository.registerUser(any())).thenAnswer((_) async =>
          const Left(ApiFailure(message: "Email is already registered")));

      // Act
      final result = await usecase(registerParams);

      // Assert
      expect(result,
          const Left(ApiFailure(message: "Email is already registered")));
      verify(() => mockAuthRepository.registerUser(any())).called(1);
    });
  });
}
