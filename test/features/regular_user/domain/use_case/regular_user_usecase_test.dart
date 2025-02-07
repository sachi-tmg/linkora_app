import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/regular_user/domain/entity/regular_user_entity.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/regular_user_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'repository.mock.dart';

void main() {
  late MockRegularUserRepository mockRepository;
  late RegularUserUsecase regularUserUsecase;
  late UploadImageUsecaseP uploadImageUsecaseP;

  setUp(() {
    mockRepository = MockRegularUserRepository();
    regularUserUsecase = RegularUserUsecase(mockRepository);
    uploadImageUsecaseP = UploadImageUsecaseP(mockRepository);
  });

  const tUserId = 'user123';
  const tProfilePicture = 'image_url';
  const tBio = 'This is a bio';
  const tRegularUserEntity = RegularUserEntity(
    userId: tUserId,
    profilePicture: tProfilePicture,
    bio: tBio,
  );

  var tFile = File('file_path');

  group('RegulaavrUserUsecase and UploadImageUsecaseP Tests', () {
    // RegularUserUsecase Tests
    test(
        'should return void when regular user details are updated successfully',
        () async {
      // Arrange
      when(() => mockRepository.regularUser(tRegularUserEntity)).thenAnswer(
        (_) async => const Right(null),
      );

      // Act
      final result = await regularUserUsecase(
        const RegularUserUsecaseParams(
          userId: tUserId,
          profilePicture: tProfilePicture,
          bio: tBio,
        ),
      );

      // Assert
      expect(result, const Right(null));
      verify(() => mockRepository.regularUser(tRegularUserEntity)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when updating regular user details fails',
        () async {
      // Arrange
      when(() => mockRepository.regularUser(tRegularUserEntity)).thenAnswer(
        (_) async =>
            const Left(ApiFailure(message: 'Error updating user details')),
      );

      // Act
      final result = await regularUserUsecase(
        const RegularUserUsecaseParams(
          userId: tUserId,
          profilePicture: tProfilePicture,
          bio: tBio,
        ),
      );

      // Assert
      expect(result,
          const Left(ApiFailure(message: 'Error updating user details')));
      verify(() => mockRepository.regularUser(tRegularUserEntity)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    // UploadImageUsecaseP Tests
    test('should upload image and return the image URL on success', () async {
      // Arrange
      when(() => mockRepository.uploadProfilePicture(tFile)).thenAnswer(
        (_) async => const Right('image.jpg'),
      );

      // Act
      final result = await uploadImageUsecaseP(
        UploadImageParamsP(file: tFile),
      );

      // Assert
      expect(result, const Right('image.jpg'));
      verify(() => mockRepository.uploadProfilePicture(tFile)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when uploading image fails', () async {
      // Arrange
      when(() => mockRepository.uploadProfilePicture(tFile)).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Image upload failed')),
      );

      // Act
      final result = await uploadImageUsecaseP(
        UploadImageParamsP(file: tFile),
      );

      // Assert
      expect(result, const Left(ApiFailure(message: 'Image upload failed')));
      verify(() => mockRepository.uploadProfilePicture(tFile)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
