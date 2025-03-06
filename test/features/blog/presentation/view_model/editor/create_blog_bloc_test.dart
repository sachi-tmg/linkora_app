import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/blog/domain/use_case/create_blog_usecase.dart';
import 'package:linkora_app/features/blog/domain/use_case/upload_blog_banner_usecase.dart';
import 'package:linkora_app/features/blog/presentation/view_model/editor/create_blog_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateBlogUseCase extends Mock implements CreateBlogUseCase {}

class MockUploadBlogBannerUsecase extends Mock
    implements UploadBlogBannerUsecase {}

void main() {
  setUpAll(() {
    // Registering a fallback value for UploadBlogBannerParams
    registerFallbackValue(UploadBlogBannerParams(file: File('test.png')));
  });

  late CreateBlogBloc createBlogBloc;
  late MockCreateBlogUseCase mockCreateBlogUseCase;
  late MockUploadBlogBannerUsecase mockUploadBlogBannerUsecase;

  setUp(() {
    mockCreateBlogUseCase = MockCreateBlogUseCase();
    mockUploadBlogBannerUsecase = MockUploadBlogBannerUsecase();
    createBlogBloc = CreateBlogBloc(
      createBlogUseCase: mockCreateBlogUseCase,
      blogBannerUseCase: mockUploadBlogBannerUsecase,
    );
  });

  tearDown(() {
    createBlogBloc.close();
  });

  group('CreateBlogBloc', () {
    blocTest<CreateBlogBloc, CreateBlogState>(
      'Emits [BlogLoading, CreateBlogInitial] when banner upload is successful',
      build: () {
        when(() => mockUploadBlogBannerUsecase.call(any()))
            .thenAnswer((_) async => const Right('uploadedImage.png'));
        return createBlogBloc;
      },
      act: (bloc) => bloc.add(UploadBanner(file: File('test.png'))),
      expect: () => [
        const BlogLoading(imageName: ''),
        const CreateBlogInitial(imageName: 'uploadedImage.png'),
      ],
      verify: (_) {
        verify(() => mockUploadBlogBannerUsecase.call(any())).called(1);
      },
    );

    blocTest<CreateBlogBloc, CreateBlogState>(
      'Emits [BlogLoading, BlogError] when banner upload fails',
      build: () {
        when(() => mockUploadBlogBannerUsecase.call(any())).thenAnswer(
            (_) async => const Left(ApiFailure(message: 'Upload failed')));
        return createBlogBloc;
      },
      act: (bloc) => bloc.add(UploadBanner(file: File('test.png'))),
      expect: () => [
        const BlogLoading(imageName: ''),
        const BlogError(message: 'Upload failed', imageName: ''),
      ],
      verify: (_) {
        verify(() => mockUploadBlogBannerUsecase.call(any())).called(1);
      },
    );
  });
}
