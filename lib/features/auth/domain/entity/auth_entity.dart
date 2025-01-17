import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String email;
  final String password;
  final String? image;
  final String? bio;

  const AuthEntity({
    this.userId,
    required this.fullName,
    required this.email,
    required this.password,
    this.image,
    this.bio,
  });

  @override
  List<Object?> get props => [userId, fullName, email, password, image, bio];
}
