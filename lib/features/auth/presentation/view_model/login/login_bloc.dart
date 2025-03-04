import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/app/di/di.dart';
import 'package:linkora_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:linkora_app/core/common/snackbar/my_snackbar.dart';
import 'package:linkora_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:linkora_app/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:linkora_app/features/blog/domain/repository/blog_repository.dart';
import 'package:linkora_app/features/blog/presentation/view_model/view_blog/blog_bloc.dart';
import 'package:linkora_app/features/home/presentation/view/home_view.dart';
import 'package:provider/provider.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  // final HomeCubit _homeCubit;
  final LoginUseCase _loginUseCase;
  final BlogBloc _blogBloc;
  final TokenSharedPrefs _tokenSharedPrefs;

  LoginBloc({
    required RegisterBloc registerBloc,
    // required HomeCubit homeCubit,
    required LoginUseCase loginUseCase,
    required BlogBloc blogBlog,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : // _homeCubit = homeCubit,
        _loginUseCase = loginUseCase,
        _tokenSharedPrefs = tokenSharedPrefs,
        _blogBloc = blogBlog,
        super(LoginState.initial()) {
    // on<NavigateHomeScreenEvent>(
    //   (event, emit) {
    //     Navigator.pushReplacement(
    //       event.context,
    //       MaterialPageRoute(
    //         builder: (context) => BlocProvider.value(
    //           value: _blogBloc,
    //           child: event.destination,
    //         ),
    //       ),
    //     );
    //   },
    // );

    on<NavigateHomeScreenEvent>(
      (event, emit) {
        Navigator.pushReplacement(
          event.context,
          MaterialPageRoute(
            builder: (context) => MultiProvider(
              providers: [
                // Provide BlogRepository
                Provider<IBlogRepository>(
                  create: (_) => getIt<IBlogRepository>(),
                ),
                // Provide BlogBloc
                BlocProvider.value(
                  value: _blogBloc,
                ),
              ],
              child: event.destination,
            ),
          ),
        );
      },
    );

    // on<NavigateImageScreenEvent>(
    //   (event, emit) {
    //     Navigator.pushReplacement(
    //       event.context,
    //       MaterialPageRoute(
    //         builder: (context) => BlocProvider.value(
    //           value: _imageBloc,
    //           child: event.destination,
    //         ),
    //       ),
    //     );
    //   },
    // );

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
            await _tokenSharedPrefs.saveToken(token);

            // Get userId and username from SharedPreferences
            final userId = await _tokenSharedPrefs.getUserId();
            final username = await _tokenSharedPrefs.getUsername();
            add(
              NavigateHomeScreenEvent(
                context: event.context,
                destination: const HomeView(),
              ),
            );
          },
        );
      },
    );
  }
}
