import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/regular_user/domain/entity/regular_user_entity.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/get_regular_user_usecase.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/get_user_written_blogs_usecase.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/update_regular_user_usecase.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/upload_profile_picture_usecase.dart';
import 'package:linkora_app/features/regular_user/presentation/view_model/profile_bloc.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockGetRegularUserUseCase extends Mock implements GetRegularUserUseCase {}

class MockUpdateRegularUserUseCase extends Mock
    implements UpdateRegularUserUseCase {}

class MockUploadProfilePictureUsecase extends Mock
    implements UploadProfilePictureUsecase {}

class MockGetUserWrittenBlogsUseCase extends Mock
    implements GetUserWrittenBlogsUseCase {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

// Dummy data for RegularUserEntity
RegularUserEntity getDummyUserEntity() {
  return RegularUserEntity(
    username: 'dummyUser',
    fullName: 'Dummy Name',
    bio: 'This is a dummy bio',
    profilePicture: 'dummyProfilePic.jpg',
    socialLinks: const {'youtube': 'youtube'},
    totalPosts: 5,
    totalReads: 100,
    blogs: const [],
    dateCreated: DateTime.now(),
  );
}

void main() {
  setUpAll(() {
    // Register fallback value for RegularUserEntity
    registerFallbackValue(getDummyUserEntity());
  });

  late ProfileBloc profileBloc;
  late MockGetRegularUserUseCase mockGetRegularUserUseCase;
  late MockUpdateRegularUserUseCase mockUpdateRegularUserUseCase;
  late MockUploadProfilePictureUsecase mockUploadProfilePictureUsecase;
  late MockGetUserWrittenBlogsUseCase mockGetUserWrittenBlogsUseCase;
  late MockTokenSharedPrefs mockTokenSharedPrefs;

  setUp(() {
    mockGetRegularUserUseCase = MockGetRegularUserUseCase();
    mockUpdateRegularUserUseCase = MockUpdateRegularUserUseCase();
    mockUploadProfilePictureUsecase = MockUploadProfilePictureUsecase();
    mockGetUserWrittenBlogsUseCase = MockGetUserWrittenBlogsUseCase();
    mockTokenSharedPrefs = MockTokenSharedPrefs();

    profileBloc = ProfileBloc(
      getRegularUserUseCase: mockGetRegularUserUseCase,
      updateRegularUserUseCase: mockUpdateRegularUserUseCase,
      uploadProfilePictureUseCase: mockUploadProfilePictureUsecase,
      getUserWrittenBlogsUseCase: mockGetUserWrittenBlogsUseCase,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  tearDown(() {
    profileBloc.close();
  });

  blocTest<ProfileBloc, ProfileState>(
    'emits error state when UpdateProfile event fails',
    build: () {
      when(() => mockUpdateRegularUserUseCase.call(any())).thenAnswer(
          (_) async =>
              const Left(ApiFailure(message: 'Failed to update profile')));
      return profileBloc;
    },
    act: (bloc) => bloc.add(const UpdateProfile(
      username: 'newUsername',
      bio: 'Updated bio',
      profilePicture: 'newProfilePicture.jpg',
      socialLinks: {'youtube': 'youtube'},
    )),
    expect: () => [
      const ProfileState.initial().copyWith(isLoading: true),
      const ProfileState.initial().copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: 'Failed to update profile',
      ),
    ],
  );
}
