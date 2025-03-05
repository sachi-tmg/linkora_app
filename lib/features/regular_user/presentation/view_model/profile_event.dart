part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String username;

  const LoadProfile({required this.username});

  @override
  List<Object?> get props => [username];
}

class LoadUserBlogs extends ProfileEvent {
  final int page;
  final bool draft;

  const LoadUserBlogs({this.page = 1, this.draft = false});

  @override
  List<Object?> get props => [page, draft];
}

class UpdateProfile extends ProfileEvent {
  final String username;
  final String bio;
  final String profilePicture;
  final Map<String, String> socialLinks;

  const UpdateProfile({
    required this.username,
    required this.bio,
    required this.profilePicture,
    required this.socialLinks,
  });

  @override
  List<Object?> get props => [username, bio, profilePicture, socialLinks];
}

class UploadProfilePicture extends ProfileEvent {
  final File file;

  const UploadProfilePicture({required this.file});

  @override
  List<Object?> get props => [file];
}
