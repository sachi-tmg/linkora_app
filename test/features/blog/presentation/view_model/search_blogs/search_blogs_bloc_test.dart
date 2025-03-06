import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/use_case/search_blog_usecase.dart';
import 'package:linkora_app/features/blog/presentation/view_model/search_blogs/search_blogs_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchBlogsUseCase extends Mock implements SearchBlogsUseCase {}

void main() {
  late SearchBlogsBloc searchBlogsBloc;
  late MockSearchBlogsUseCase mockSearchBlogsUseCase;

  setUp(() {
    mockSearchBlogsUseCase = MockSearchBlogsUseCase();
    searchBlogsBloc =
        SearchBlogsBloc(searchBlogsUseCase: mockSearchBlogsUseCase);
  });

  const testQuery = "flutter";

  tearDown(() {
    searchBlogsBloc.close();
  });

  final blogEntity = BlogEntity(
    blogId: '1',
    title: 'Test Blog',
    description: 'Description',
    blogPicture: 'image.png',
    activity: const {},
    dateCreated: DateTime.now(),
    user: const {},
  );

  // Test case 1: Successful search
  blocTest<SearchBlogsBloc, SearchBlogsState>(
    'Emits [SearchBlogsLoading, SearchBlogsLoaded] when search is successful',
    build: () {
      when(() => mockSearchBlogsUseCase(any(), page: any(named: 'page')))
          .thenAnswer((_) async => Right([blogEntity]));
      return searchBlogsBloc;
    },
    act: (bloc) => bloc.add(const SearchBlogsQueryEvent(testQuery, page: 1)),
    expect: () => [
      SearchBlogsLoading(),
      SearchBlogsLoaded([blogEntity]),
    ],
    verify: (_) {
      verify(() => mockSearchBlogsUseCase(testQuery, page: 1)).called(1);
    },
  );

  // Test case 2: Search fails
  blocTest<SearchBlogsBloc, SearchBlogsState>(
    'Emits [SearchBlogsLoading, SearchBlogsError] when search fails',
    build: () {
      when(() => mockSearchBlogsUseCase(any(), page: any(named: 'page')))
          .thenAnswer(
              (_) async => const Left(ApiFailure(message: 'Search failed')));
      return searchBlogsBloc;
    },
    act: (bloc) => bloc.add(const SearchBlogsQueryEvent(testQuery, page: 1)),
    expect: () => [
      SearchBlogsLoading(),
      const SearchBlogsError('Search failed'),
    ],
    verify: (_) {
      verify(() => mockSearchBlogsUseCase(testQuery, page: 1)).called(1);
    },
  );

  // Test case 3: Empty query
  blocTest<SearchBlogsBloc, SearchBlogsState>(
    'Emits [SearchBlogsLoading, SearchBlogsLoaded] with empty list when query is empty',
    build: () {
      when(() => mockSearchBlogsUseCase(any(), page: any(named: 'page')))
          .thenAnswer((_) async =>
              const Right([])); // Return empty list for empty query
      return searchBlogsBloc;
    },
    act: (bloc) => bloc.add(const SearchBlogsQueryEvent('', page: 1)),
    expect: () => [
      SearchBlogsLoading(),
      const SearchBlogsLoaded([]), // Expect an empty list
    ],
    verify: (_) {
      verify(() => mockSearchBlogsUseCase('', page: 1)).called(1);
    },
  );
}
