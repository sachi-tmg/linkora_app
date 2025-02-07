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

    test('should return Failure when required fields are missing', () async {
      // Arrange
      const invalidParams = RegisterUserParams(
        fullName: 'Sachi Tamang',
        email: '',
        password: 'sachi123',
      );

      when(() => mockAuthRepository.registerUser(any())).thenAnswer((_) async =>
          const Left(ApiFailure(message: "One or more credentials are empty")));

      // Act
      final result = await usecase(invalidParams);

      // Assert
      expect(result,
          const Left(ApiFailure(message: "One or more credentials are empty")));
      verify(() => mockAuthRepository.registerUser(any())).called(1);
    });

    test('should return Failure when there is Api Failure', () async {
      // Arrange
      when(() => mockAuthRepository.registerUser(any())).thenAnswer((_) async =>
          const Left(ApiFailure(message: "Unexpected server error")));

      // Act
      final result = await usecase(registerParams);

      // Assert
      expect(
          result, const Left(ApiFailure(message: "Unexpected server error")));
      verify(() => mockAuthRepository.registerUser(any())).called(1);
    });

    test('should successfully register a user and return Right(null)',
        () async {
      // Arrange
      when(() => mockAuthRepository.registerUser(any()))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase(registerParams);

      // Assert
      expect(result, const Right(null));
      verify(() => mockAuthRepository.registerUser(any())).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
