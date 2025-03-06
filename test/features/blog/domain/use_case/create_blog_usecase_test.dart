import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/data/model/blog_api_model.dart';
import 'package:linkora_app/features/blog/domain/use_case/create_blog_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'repository.mock.dart';

void main() {
  late MockBlogRepository mockRepository;
  late CreateBlogUseCase useCase;

  setUp(() {
    mockRepository = MockBlogRepository();
    useCase = CreateBlogUseCase(repository: mockRepository);
  });

  final blogApiModel = BlogApiModel(
    title: 'Test Blog',
    description: 'Test Description',
    blogPicture: 'https://link.to/picture',
    content: const ['Content of the blog'],
    activity: const {'views': 100},
    tags: const ['test'],
    dateCreated: DateTime.now(),
    user: const {'id': 'user123', 'name': 'Test User'},
  );

  const String successResponse = 'Blog created successfully';

  group('CreateBlogUseCase', () {
    test('should return a success message when the repository is successful',
        () async {
      // Arrange: Mock the repository method to return a successful response
      when(() => mockRepository.createBlog(blogApiModel))
          .thenAnswer((_) async => const Right(successResponse));

      // Act: Call the use case with the blogApiModel
      final result = await useCase(blogApiModel);

      // Assert: Verify the result is the expected Right (success) with the success message
      expect(result, const Right(successResponse));

      // Verify: Ensure the repository method was called with the correct parameter
      verify(() => mockRepository.createBlog(blogApiModel)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a failure when the repository fails', () async {
      // Arrange: Mock the repository method to return a failure
      when(() => mockRepository.createBlog(blogApiModel)).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Error creating blog')));

      // Act: Call the use case with the blogApiModel
      final result = await useCase(blogApiModel);

      // Assert: Verify the result is a Left (failure) with the failure message
      expect(result, const Left(ApiFailure(message: 'Error creating blog')));

      // Verify: Ensure the repository method was called with the correct parameter
      verify(() => mockRepository.createBlog(blogApiModel)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
