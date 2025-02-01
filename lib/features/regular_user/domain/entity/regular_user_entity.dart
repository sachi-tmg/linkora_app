import 'package:equatable/equatable.dart';

class RegularUserEntity extends Equatable {
  final String userId;
  final String? profilePicture;
  final String? bio;

  const RegularUserEntity({
    required this.userId,
    this.profilePicture,
    this.bio,
  });

  @override
  List<Object?> get props => [userId, profilePicture, bio];
}
