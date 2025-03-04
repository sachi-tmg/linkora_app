import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:linkora_app/features/blog/data/model/blog_api_model.dart';
import 'package:linkora_app/features/blog/domain/use_case/create_blog_usecase.dart';
import 'package:linkora_app/features/blog/domain/use_case/upload_blog_banner_usecase.dart';

part 'create_blog_event.dart';
part 'create_blog_state.dart';

class CreateBlogBloc extends Bloc<CreateBlogEvent, CreateBlogState> {
  final CreateBlogUseCase _createBlogUseCase;
  final UploadBlogBannerUsecase _blogBannerUsecase;

  CreateBlogBloc({
    required CreateBlogUseCase createBlogUseCase,
    required UploadBlogBannerUsecase blogBannerUseCase,
  })  : _createBlogUseCase = createBlogUseCase,
        _blogBannerUsecase = blogBannerUseCase,
        super(const CreateBlogInitial(imageName: '')) {
    on<CreateBlogRequested>(_onCreateBlogRequested);
    on<UploadBanner>(_onUploadBanner);
  }

  Future<void> _onCreateBlogRequested(
      CreateBlogRequested event, Emitter<CreateBlogState> emit) async {
    print("Creating blog with image in bloc: ${state.imageName}");
    emit(BlogLoading(imageName: state.imageName));
    final blog = BlogApiModel(
      title: event.blog.title,
      description: event.blog.description,
      blogPicture: state.imageName ?? '',
      content: event.blog.content,
      tags: event.blog.tags,
      draft: event.blog.draft,
    );

    final result = await _createBlogUseCase(blog);
    result.fold(
      (failure) {
        emit(BlogError(
            message: 'Error creating blog with image: ${failure.message}',
            imageName: state.imageName));
      },
      (blogId) {
        emit(BlogCreated(blogId: blogId, imageName: state.imageName));
      },
    );
  }

  Future<void> _onUploadBanner(
    UploadBanner event,
    Emitter<CreateBlogState> emit,
  ) async {
    emit(BlogLoading(imageName: state.imageName));
    final result = await _blogBannerUsecase.call(
      UploadBlogBannerParams(file: event.file),
    );
    result.fold(
        (failure) => emit(
            BlogError(message: failure.message, imageName: state.imageName)),
        (imageName) {
      emit(CreateBlogInitial(imageName: imageName));
      print("Image uploaded successfully in bloc: $imageName");
    });
  }
}
