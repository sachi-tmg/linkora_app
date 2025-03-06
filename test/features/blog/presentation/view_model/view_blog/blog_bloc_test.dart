import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/use_case/get_all_blog_usecase.dart';
import 'package:linkora_app/features/blog/domain/use_case/get_blog_usecase.dart';
import 'package:linkora_app/features/blog/presentation/view_model/view_blog/blog_bloc.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/delete_blog_usecase.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/like_blog_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockGetLatestBlogsUseCase extends Mock implements GetLatestBlogsUseCase {}

class MockGetBlogUseCase extends Mock implements GetBlogUseCase {}

class MockDeleteBlogUsecase extends Mock implements DeleteBlogUseCase {}

class MockLikeBlogUsecase extends Mock implements LikeBlogUseCase {}

void main() {
  late BlogBloc blogBloc;
  late MockGetLatestBlogsUseCase mockGetLatestBlogsUseCase;
  late MockGetBlogUseCase mockGetBlogUseCase;
  late MockDeleteBlogUsecase mockDeleteBlogUsecase;
  late MockLikeBlogUsecase mockLikeBlogUsecase;

  setUp(() {
    mockGetLatestBlogsUseCase = MockGetLatestBlogsUseCase();
    mockGetBlogUseCase = MockGetBlogUseCase();
    mockDeleteBlogUsecase = MockDeleteBlogUsecase();
    mockLikeBlogUsecase = MockLikeBlogUsecase();
    blogBloc = BlogBloc(
      getLatestBlogsUseCase: mockGetLatestBlogsUseCase,
      getBlogUseCase: mockGetBlogUseCase,
      deleteBlogUseCase: mockDeleteBlogUsecase,
      likeBlogUseCase: mockLikeBlogUsecase,
    );
  });

  final testBlog = BlogEntity(
    blogId: '1',
    title: 'Test Blog',
    description: 'Test Description',
    blogPicture: 'test.jpg',
    content: const ['Sample Content'],
    draft: false,
    activity: const {},
    tags: const ['flutter'],
    dateCreated: DateTime.now(),
    user: const {'id': 'user1', 'name': 'Test User'},
    profilePicture: 'user.jpg',
  );

  blocTest<BlogBloc, BlogState>(
    'Emits [BlogLoading, BlogLoaded] when FetchLatestBlogs succeeds',
    build: () {
      when(() => mockGetLatestBlogsUseCase(any()))
          .thenAnswer((_) async => Right([testBlog]));
      return blogBloc;
    },
    act: (bloc) => bloc.add(const FetchLatestBlogs(page: 1)),
    expect: () => [
      BlogLoading(),
      BlogLoaded(blogs: [testBlog]),
    ],
    verify: (_) {
      verify(() => mockGetLatestBlogsUseCase(1)).called(1);
    },
  );

  blocTest<BlogBloc, BlogState>(
    'Emits [BlogLoading, BlogError] when FetchLatestBlogs fails',
    build: () {
      when(() => mockGetLatestBlogsUseCase(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Error fetching blogs')));
      return blogBloc;
    },
    act: (bloc) => bloc.add(const FetchLatestBlogs(page: 1)),
    expect: () => [
      BlogLoading(),
      const BlogError(message: 'Error fetching blogs'),
    ],
  );

  blocTest<BlogBloc, BlogState>(
    'Emits [BlogLoading, BlogDetailLoaded] when FetchBlogById succeeds',
    build: () {
      when(() => mockGetBlogUseCase(any()))
          .thenAnswer((_) async => Right(testBlog));
      return blogBloc;
    },
    act: (bloc) => bloc.add(const FetchBlogById(blogId: '1')),
    expect: () => [
      BlogLoading(),
      BlogDetailLoaded(blog: testBlog),
    ],
    verify: (_) {
      verify(() => mockGetBlogUseCase('1')).called(1);
    },
  );

  blocTest<BlogBloc, BlogState>(
    'Emits [BlogLoading, BlogError] when FetchBlogById fails',
    build: () {
      when(() => mockGetBlogUseCase(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Error fetching blog')));
      return blogBloc;
    },
    act: (bloc) => bloc.add(const FetchBlogById(blogId: '1')),
    expect: () => [
      BlogLoading(),
      const BlogError(message: 'Error fetching blog'),
    ],
  );
}
