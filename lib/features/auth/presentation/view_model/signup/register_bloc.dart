import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:linkora_app/core/common/snackbar/my_snackbar.dart';
import 'package:linkora_app/features/auth/domain/use_case/register_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterBloc({
    required RegisterUseCase registerUseCase,
  })  : _registerUseCase = registerUseCase,
        super(RegisterState.initial()) {
    on<RegisterUser>(_onRegisterEvent);
  }

  void _onRegisterEvent(
    RegisterUser event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _registerUseCase.call(RegisterUserParams(
      fullName: event.fullName,
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (l) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        Future.delayed(Duration.zero, () {
          showMySnackBar(
            context: event.context,
            message: "Registration Failed: ${l.message}",
          );
        });
      },
      (r) {
        Future.delayed(Duration.zero, () {
          showMySnackBar(
            context: event.context,
            message: "Registration Successful",
            color: Colors.green,
          );
        });
      },
    );
  }
}
