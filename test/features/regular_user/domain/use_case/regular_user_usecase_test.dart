import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/regular_user_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'repository.mock.dart';

void main() {
  late MockRegularUserRepository mockRepository;
  late UploadImageUsecaseP uploadImageUsecaseP;

  setUp(() {
    mockRepository = MockRegularUserRepository();
    uploadImageUsecaseP = UploadImageUsecaseP(mockRepository);
  });

  var tFile = File('file_path');

  group('UploadImageUsecaseP Tests', () {
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
