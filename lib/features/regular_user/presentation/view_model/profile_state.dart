part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? imageName;
  final RegularUserEntity? regularUser;
  final String? errorMessage;

  const ProfileState({
    required this.isLoading,
    required this.isSuccess,
    this.imageName,
    this.regularUser,
    this.errorMessage,
  });

  const ProfileState.initial()
      : isLoading = false,
        isSuccess = false,
        imageName = null,
        regularUser = null,
        errorMessage = null;

  ProfileState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? imageName,
    RegularUserEntity? regularUser,
    String? errorMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      imageName: imageName ?? this.imageName,
      regularUser: regularUser ?? this.regularUser,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        imageName,
        regularUser,
        errorMessage,
      ];
}
