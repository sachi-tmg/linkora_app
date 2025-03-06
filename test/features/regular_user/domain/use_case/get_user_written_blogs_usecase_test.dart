import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/get_user_written_blogs_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../../../blog/domain/use_case/repository.mock.dart';

void main() {
  late GetUserWrittenBlogsUseCase useCase;
  late MockBlogRepository mockBlogRepository;

  setUp(() {
    mockBlogRepository = MockBlogRepository();
    useCase = GetUserWrittenBlogsUseCase(mockBlogRepository);
  });

  final Map<String, dynamic> params = {'page': 1, 'draft': false};
  final List<BlogEntity> testBlogs = [
    BlogEntity(
      blogId: '1',
      title: 'Blog 1',
      description: 'Description of Blog 1',
      blogPicture: 'https://example.com/blog1.jpg',
      activity: const {'views': 100},
      dateCreated: DateTime.now(),
      user: const {'userId': 'user123'},
    ),
    BlogEntity(
      blogId: '2',
      title: 'Blog 2',
      description: 'Description of Blog 2',
      blogPicture: 'https://example.com/blog2.jpg',
      activity: const {'views': 200},
      dateCreated: DateTime.now(),
      user: const {'userId': 'user123'},
    ),
  ];

  group('GetUserWrittenBlogsUseCase', () {
    test('should return a list of blogs when the repository is successful',
        () async {
      // Arrange: Mock the repository to return a successful response
      when(() => mockBlogRepository.getUserWrittenBlogs(page: 1, draft: false))
          .thenAnswer((_) async => Right(testBlogs));

      // Act: Call the use case
      final result = await useCase(params);

      // Assert: Verify the result is the expected Right (success) with the list of blogs
      expect(result, Right(testBlogs));

      // Verify: Ensure the repository method was called with the correct parameters
      verify(() =>
              mockBlogRepository.getUserWrittenBlogs(page: 1, draft: false))
          .called(1);
      verifyNoMoreInteractions(mockBlogRepository);
    });

    test('should return a Failure when the repository fails', () async {
      // Arrange: Mock the repository to return a failure
      when(() => mockBlogRepository.getUserWrittenBlogs(page: 1, draft: false))
          .thenAnswer((_) async =>
              const Left(ApiFailure(message: 'Error fetching blogs')));

      // Act: Call the use case
      final result = await useCase(params);

      // Assert: Verify the result is a Left (failure) with the failure message
      expect(result, const Left(ApiFailure(message: 'Error fetching blogs')));

      // Verify: Ensure the repository method was called with the correct parameters
      verify(() =>
              mockBlogRepository.getUserWrittenBlogs(page: 1, draft: false))
          .called(1);
      verifyNoMoreInteractions(mockBlogRepository);
    });
  });
}
