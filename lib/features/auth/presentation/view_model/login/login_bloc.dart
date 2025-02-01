import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:linkora_app/core/common/snackbar/my_snackbar.dart';
import 'package:linkora_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:linkora_app/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:linkora_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:linkora_app/features/regular_user/presentation/view/image_view.dart';
import 'package:linkora_app/features/regular_user/presentation/view_model/image_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final HomeCubit _homeCubit;
  final LoginUseCase _loginUseCase;
  final ImageBloc _imageBloc;
  final TokenSharedPrefs _tokenSharedPrefs;

  LoginBloc({
    required RegisterBloc registerBloc,
    required HomeCubit homeCubit,
    required LoginUseCase loginUseCase,
    required ImageBloc imagebloc,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _homeCubit = homeCubit,
        _loginUseCase = loginUseCase,
        _imageBloc = imagebloc,
        _tokenSharedPrefs = tokenSharedPrefs,
        super(LoginState.initial()) {
    on<NavigateHomeScreenEvent>(
      (event, emit) {
        Navigator.pushReplacement(
          event.context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: _homeCubit,
              child: event.destination,
            ),
          ),
        );
      },
    );

    on<NavigateImageScreenEvent>(
      (event, emit) {
        Navigator.pushReplacement(
          event.context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: _imageBloc,
              child: event.destination,
            ),
          ),
        );
      },
    );

    on<LoginUserEvent>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true));
        final result = await _loginUseCase(
          LoginParams(
            email: event.email,
            password: event.password,
          ),
        );

        result.fold(
          (failure) {
            emit(state.copyWith(isLoading: false, isSuccess: false));
            showMySnackBar(
              context: event.context,
              message: "Invalid Credentials",
              color: Colors.red,
            );
          },
          (token) async {
            emit(state.copyWith(isLoading: false, isSuccess: true));
            // Fetch userId from SharedPreferences
            final userIdResult = await _tokenSharedPrefs.getUserId();

            userIdResult.fold(
              (failure) {
                // Handle error if userId fetching fails
                showMySnackBar(
                  context: event.context,
                  message: "Failed to fetch userId",
                  color: Colors.red,
                );
              },
              (userId) {
                // Navigate to UploadProfile screen with userId
                add(
                  NavigateImageScreenEvent(
                    context: event.context,
                    destination:
                        UploadProfile(userId: userId), // Pass userId here
                  ),
                );
              },
            );
            // showMySnackBar(
            //   context: event.context,
            //   message: "Login Success",
            //   color: Colors.green,
            // );

            //_homeCubit.setToken(token);
          },
        );
      },
    );
  }
}
