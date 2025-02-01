part of 'login_bloc.dart';

class LoginState {
  final bool isLoading;
  final bool isSuccess;
  final String? userId;

  LoginState({
    required this.isLoading,
    required this.isSuccess,
    this.userId,
  });

  LoginState.initial()
      : isLoading = false,
        isSuccess = false,
        userId = null;

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? userId,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      userId: userId ?? this.userId,
    );
  }
}
