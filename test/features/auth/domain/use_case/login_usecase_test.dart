import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/auth/domain/repository/auth_repository.dart';
import 'package:linkora_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

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
}
