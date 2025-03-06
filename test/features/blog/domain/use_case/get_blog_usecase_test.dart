import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/use_case/get_blog_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'repository.mock.dart';

void main() {
  late MockBlogRepository mockRepository;
  late GetBlogUseCase useCase;

  setUp(() {
    mockRepository = MockBlogRepository();
    useCase = GetBlogUseCase(mockRepository);
  });

  const String testBlogId = '123';
  final BlogEntity testBlog = BlogEntity(
    blogId: testBlogId,
    title: 'Test Blog',
    description: 'Description of Test Blog',
    blogPicture: 'url_to_blog_picture',
    content: const ['Content of the blog'],
    draft: false,
    activity: const {'views': 100},
    tags: const ['tag1', 'tag2'],
    dateCreated: DateTime.now(),
    user: const {'id': 'user1', 'name': 'User One'},
  );

  group('GetBlogUseCase', () {
    test('should return a blog entity when the repository is successful',
        () async {
      // Arrange: Mock the repository to return a successful response
      when(() => mockRepository.getBlog(testBlogId))
          .thenAnswer((_) async => Right(testBlog));

      // Act: Call the use case with the blog ID
      final result = await useCase(testBlogId);

      // Assert: Verify the result is the expected Right (success) with the BlogEntity
      expect(result, Right(testBlog));

      // Verify: Ensure the repository method was called with the correct parameter
      verify(() => mockRepository.getBlog(testBlogId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a failure when the repository fails', () async {
      // Arrange: Mock the repository to return a failure
      when(() => mockRepository.getBlog(testBlogId)).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Error fetching blog')));

      // Act: Call the use case with the blog ID
      final result = await useCase(testBlogId);

      // Assert: Verify the result is a Left (failure) with the failure message
      expect(result, const Left(ApiFailure(message: 'Error fetching blog')));

      // Verify: Ensure the repository method was called with the correct parameter
      verify(() => mockRepository.getBlog(testBlogId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
