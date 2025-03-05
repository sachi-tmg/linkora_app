part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? imageName;
  final RegularUserEntity? regularUser;
  final List<BlogEntity>? blogs;
  final String? errorMessage;

  const ProfileState({
    required this.isLoading,
    required this.isSuccess,
    this.imageName,
    this.regularUser,
    this.blogs,
    this.errorMessage,
  });

  const ProfileState.initial()
      : isLoading = false,
        isSuccess = false,
        imageName = null,
        regularUser = null,
        blogs = null,
        errorMessage = null;

  ProfileState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? imageName,
    RegularUserEntity? regularUser,
    List<BlogEntity>? blogs,
    String? errorMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      imageName: imageName ?? this.imageName,
      regularUser: regularUser ?? this.regularUser,
      blogs: blogs ?? this.blogs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        imageName,
        regularUser,
        blogs,
        errorMessage,
      ];
}
