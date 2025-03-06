import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/use_case/get_all_blog_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'repository.mock.dart';

void main() {
  late MockBlogRepository mockRepository;
  late GetLatestBlogsUseCase useCase;

  setUp(() {
    mockRepository = MockBlogRepository();
    useCase = GetLatestBlogsUseCase(mockRepository);
  });

  final List<BlogEntity> testBlogs = [
    BlogEntity(
      blogId: '1',
      title: 'Blog 1',
      description: 'This is the description of Blog 1',
      blogPicture: 'url_to_blog_1_picture',
      content: const ['Content of Blog 1'],
      draft: false,
      activity: const {'views': 100},
      tags: const ['tag1', 'tag2'],
      dateCreated: DateTime.now(),
      user: const {'id': 'user1', 'name': 'User One'},
    ),
    BlogEntity(
      blogId: '2',
      title: 'Blog 2',
      description: 'This is the description of Blog 2',
      blogPicture: 'url_to_blog_2_picture',
      content: const ['Content of Blog 2'],
      draft: false,
      activity: const {'views': 200},
      tags: const ['tag3', 'tag4'],
      dateCreated: DateTime.now(),
      user: const {'id': 'user2', 'name': 'User Two'},
    ),
  ];

  const int testPage = 1;

  group('GetLatestBlogsUseCase', () {
    test('should return a list of blogs when the repository is successful',
        () async {
      // Arrange: Mock the repository method to return a successful response
      when(() => mockRepository.getLatestBlogs(testPage))
          .thenAnswer((_) async => Right(testBlogs));

      // Act: Call the use case
      final result = await useCase(testPage);

      // Assert: Verify the result is the expected Right (success) with the list of blogs
      expect(result, Right(testBlogs));

      // Verify: Ensure the repository method was called with the correct parameter
      verify(() => mockRepository.getLatestBlogs(testPage)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a Failure when the repository fails', () async {
      // Arrange: Mock the repository method to return a failure
      when(() => mockRepository.getLatestBlogs(testPage)).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Error fetching blogs')));

      // Act: Call the use case
      final result = await useCase(testPage);

      // Assert: Verify the result is a Left (failure) with the failure message
      expect(result, const Left(ApiFailure(message: 'Error fetching blogs')));

      // Verify: Ensure the repository method was called with the correct parameter
      verify(() => mockRepository.getLatestBlogs(testPage)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
