import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/use_case/search_blog_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'repository.mock.dart';

void main() {
  late MockBlogRepository mockRepository;
  late SearchBlogsUseCase useCase;

  setUp(() {
    mockRepository = MockBlogRepository();
    useCase = SearchBlogsUseCase(mockRepository);
  });

  const String testQuery = 'test query';
  final List<BlogEntity> testBlogs = [
    BlogEntity(
      blogId: '1',
      title: 'Test Blog 1',
      description: 'Description of Test Blog 1',
      blogPicture: 'url_to_blog_picture',
      content: const ['Content of the blog'],
      draft: false,
      activity: const {'views': 100},
      tags: const ['tag1'],
      dateCreated: DateTime.now(),
      user: const {'id': 'user1', 'name': 'User One'},
    ),
    BlogEntity(
      blogId: '2',
      title: 'Test Blog 2',
      description: 'Description of Test Blog 2',
      blogPicture: 'url_to_blog_picture_2',
      content: const ['Content of the blog'],
      draft: false,
      activity: const {'views': 50},
      tags: const ['tag2'],
      dateCreated: DateTime.now(),
      user: const {'id': 'user2', 'name': 'User Two'},
    ),
  ];

  const int testPage = 1;

  group('SearchBlogsUseCase', () {
    test('should return a list of blogs when the repository is successful',
        () async {
      // Arrange: Mock the repository to return a successful response
      when(() => mockRepository.searchBlogs(testQuery, page: testPage))
          .thenAnswer((_) async => Right(testBlogs));

      // Act: Call the use case with the search query
      final result = await useCase(testQuery, page: testPage);

      // Assert: Verify the result is the expected Right (success) with the list of blogs
      expect(result, Right(testBlogs));

      // Verify: Ensure the repository method was called with the correct parameters
      verify(() => mockRepository.searchBlogs(testQuery, page: testPage))
          .called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a failure when the repository fails', () async {
      // Arrange: Mock the repository to return a failure
      when(() => mockRepository.searchBlogs(testQuery, page: testPage))
          .thenAnswer((_) async =>
              const Left(ApiFailure(message: 'Error searching blogs')));

      // Act: Call the use case with the search query
      final result = await useCase(testQuery, page: testPage);

      // Assert: Verify the result is a Left (failure) with the failure message
      expect(result, const Left(ApiFailure(message: 'Error searching blogs')));

      // Verify: Ensure the repository method was called with the correct parameters
      verify(() => mockRepository.searchBlogs(testQuery, page: testPage))
          .called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
