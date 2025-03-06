import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/regular_user/domain/entity/regular_user_entity.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/update_regular_user_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'repository.mock.dart';

void main() {
  late UpdateRegularUserUseCase useCase;
  late MockRegularUserRepository mockRepository;

  setUp(() {
    mockRepository = MockRegularUserRepository();
    useCase = UpdateRegularUserUseCase(mockRepository);
  });

  final regularUser = RegularUserEntity(
    userId: 'user123',
    username: 'testuser',
    fullName: 'Test User',
    profilePicture: 'https://example.com/profile.jpg',
    bio: 'A test user.',
    socialLinks: {'facebook': 'https://facebook.com/testuser'},
    totalPosts: 10,
    totalReads: 100,
    blogs: ['blog1', 'blog2'],
    dateCreated: DateTime.now(),
  );

  group('UpdateRegularUserUseCase', () {
    test('should return void when the update is successful', () async {
      // Arrange: Mock the repository to return a successful response (Right)
      when(() => mockRepository.updateRegularUser(regularUser))
          .thenAnswer((_) async => const Right(Void));

      // Act: Call the use case with the regularUser entity
      final result = await useCase(regularUser);

      // Assert: Verify the result is a Right (success) with void
      expect(result, const Right(Void));

      // Verify: Ensure the repository method was called with the correct parameter
      verify(() => mockRepository.updateRegularUser(regularUser)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a Failure when the update fails', () async {
      // Arrange: Mock the repository to return a failure (Left)
      when(() => mockRepository.updateRegularUser(regularUser)).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Update failed')));

      // Act: Call the use case with the regularUser entity
      final result = await useCase(regularUser);

      // Assert: Verify the result is a Left (failure) with the failure message
      expect(result, const Left(ApiFailure(message: 'Update failed')));

      // Verify: Ensure the repository method was called with the correct parameter
      verify(() => mockRepository.updateRegularUser(regularUser)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
