import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'repository.mock.dart';
import 'token.mock.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late LoginUseCase loginUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    loginUseCase = LoginUseCase(mockAuthRepository, mockTokenSharedPrefs);
  });

  const tEmail = 'sachi@gmail.com';
  const tPassword = 'sachi123';
  const tToken = 'abc1234';

  group('Login Tests', () {
    test('should call login and save token successfully', () async {
      // Arrange
      when(() => mockAuthRepository.loginUser(tEmail, tPassword)).thenAnswer(
        (_) async => const Right(tToken),
      );
      when(() => mockTokenSharedPrefs.saveToken(tToken)).thenAnswer(
        (_) async => const Right(null),
      );
      when(() => mockTokenSharedPrefs.getToken()).thenAnswer(
        (_) async => const Right(tToken),
      );

      // Act
      final result = await loginUseCase(
          const LoginParams(email: tEmail, password: tPassword));

      // Assert
      expect(
          result,
          const Right(
              tToken)); // Expect the result to be the token wrapped in Right
      verify(() => mockAuthRepository.loginUser(tEmail, tPassword)).called(1);
      verify(() => mockTokenSharedPrefs.saveToken(tToken)).called(1);
      verify(() => mockTokenSharedPrefs.getToken()).called(1);
    });

    test('should return failure when login fails', () async {
      // Arrange
      when(() => mockAuthRepository.loginUser(tEmail, tPassword)).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Invalid credentials')),
      );

      // Act
      final result = await loginUseCase(
          const LoginParams(email: tEmail, password: tPassword));

      // Assert
      expect(result, const Left(ApiFailure(message: 'Invalid credentials')));
      verify(() => mockAuthRepository.loginUser(tEmail, tPassword)).called(1);
      verifyZeroInteractions(mockTokenSharedPrefs);
    });

    test('returns Failure when email is empty', () async {
      // Arrange
      const emptyEmailData = LoginParams(email: "", password: "kirtan123");
      when(() => mockAuthRepository.loginUser(any(), any())).thenAnswer(
          (_) async =>
              const Left(ApiFailure(message: "email cannot be empty")));

      // Act
      final result = await loginUseCase(emptyEmailData);

      // Assert
      expect(result, const Left(ApiFailure(message: "email cannot be empty")));
      verify(() => mockAuthRepository.loginUser(any(), any())).called(1);
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
    });

    test('returns Failure when password is empty', () async {
      // Arrange
      const emptyPasswordData = LoginParams(email: "kirtan", password: "");
      when(() => mockAuthRepository.loginUser(any(), any())).thenAnswer(
          (_) async =>
              const Left(ApiFailure(message: "Password cannot be empty")));

      // Act
      final result = await loginUseCase(emptyPasswordData);

      // Assert
      expect(
          result, const Left(ApiFailure(message: "Password cannot be empty")));
      verify(() => mockAuthRepository.loginUser(any(), any())).called(1);
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
    });

    test('returns Failure on server error', () async {
      // Arrange
      when(() => mockAuthRepository.loginUser(any(), any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: "Server error")));

      // Act
      final result = await loginUseCase(
          const LoginParams(email: tEmail, password: tPassword));

      // Assert
      expect(result, const Left(ApiFailure(message: "Server error")));
      verify(() => mockAuthRepository.loginUser(any(), any())).called(1);
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
    });
  });
}
