part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class LoadImage extends RegisterEvent {
  final File file;

  const LoadImage({
    required this.file,
  });
}

class RegisterUser extends RegisterEvent {
  final BuildContext context;
  final String fullName;
  final String email;
  final String password;
  final String? image;

  const RegisterUser({
    required this.context,
    required this.fullName,
    required this.email,
    required this.password,
    this.image,
  });
}
