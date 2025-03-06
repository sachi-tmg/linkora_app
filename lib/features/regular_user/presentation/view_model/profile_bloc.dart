import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/regular_user/domain/entity/regular_user_entity.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/get_regular_user_usecase.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/get_user_written_blogs_usecase.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/update_regular_user_usecase.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/upload_profile_picture_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetRegularUserUseCase getRegularUserUseCase;
  final UpdateRegularUserUseCase updateRegularUserUseCase;
  final UploadProfilePictureUsecase uploadProfilePictureUseCase;
  final GetUserWrittenBlogsUseCase getUserWrittenBlogsUseCase;
  final TokenSharedPrefs _tokenSharedPrefs;

  ProfileBloc({
    required this.getRegularUserUseCase,
    required this.updateRegularUserUseCase,
    required this.uploadProfilePictureUseCase,
    required this.getUserWrittenBlogsUseCase,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _tokenSharedPrefs = tokenSharedPrefs,
        super(const ProfileState.initial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UploadProfilePicture>(_onUploadProfilePicture);
    on<LoadUserBlogs>(_onLoadUserBlogs);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Get token and username from SharedPreferences
      final usernameResult = await _tokenSharedPrefs.getUsername();

      // Handle the result of getting the username from SharedPreferences
      final username = usernameResult.fold(
        (failure) {
          // Handle the failure case
          emit(state.copyWith(
            isLoading: false,
            errorMessage: failure.message.isEmpty
                ? 'An error occurred while retrieving the username.'
                : failure.message,
          ));
          return null; // or handle accordingly
        },
        (username) => username, // Success case
      );

      if (username == null) {
        // Handle the case where username retrieval failed
        return;
      }

      final result = await getRegularUserUseCase.call(username);

      result.fold(
        (failure) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: failure.message.isEmpty
                ? 'An error occurred while loading the profile.'
                : failure.message,
          ));
        },
        (regularUser) {
          emit(state.copyWith(
            isLoading: false,
            isSuccess: true,
            regularUser: regularUser,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadUserBlogs(
    LoadUserBlogs event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    print("Loading user blogs: page ${event.page}, draft: ${event.draft}");
    try {
      final result = await getUserWrittenBlogsUseCase.call({
        'page': event.page,
        'draft': event.draft,
      });

      result.fold(
        (failure) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: failure.message.isEmpty
                ? 'An error occurred while fetching blogs.'
                : failure.message,
          ));
        },
        (blogs) {
          emit(state.copyWith(
            isLoading: false,
            isSuccess: true,
            blogs: blogs, // Store fetched blogs in state
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final updatedUser = RegularUserEntity(
      username: event.username,
      fullName: state.regularUser?.fullName ?? '',
      bio: event.bio,
      profilePicture: event.profilePicture.isEmpty
          ? state.regularUser?.profilePicture ?? ''
          : event.profilePicture,
      socialLinks: event.socialLinks,
      totalPosts: state.regularUser?.totalPosts ?? 0,
      totalReads: state.regularUser?.totalReads ?? 0,
      blogs: state.regularUser?.blogs ?? [],
      dateCreated: state.regularUser?.dateCreated ?? DateTime.now(),
    );

    // Pass the RegularUserEntity to the use case
    final result = await updateRegularUserUseCase.call(updatedUser);
    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (_) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          regularUser: updatedUser,
        ));
      },
    );
  }

  Future<void> _onUploadProfilePicture(
    UploadProfilePicture event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await uploadProfilePictureUseCase.call(
      UploadProfileParams(file: event.file),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (imageName) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          imageName: imageName,
        ));
      },
    );
  }
}
