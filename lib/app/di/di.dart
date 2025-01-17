import 'package:get_it/get_it.dart';
import 'package:linkora_app/core/network/hive_service.dart';
import 'package:linkora_app/features/auth/data/data_source/local_datasource/auth_local_data_source.dart';
import 'package:linkora_app/features/auth/data/repository/auth_local_repository/auth_local_repository.dart';
import 'package:linkora_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:linkora_app/features/auth/domain/use_case/register_usecase.dart';
import 'package:linkora_app/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:linkora_app/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:linkora_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:linkora_app/features/onboarding/presentation/view_model/onboarding_bloc.dart';
import 'package:linkora_app/features/splash/presentation/view_model/splash_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initSplashDependencies();
  await _initOnboardingDependencies();
  await _initHomeDependencies();
  await _initDashboardDependencies();
  await _initRegisterDependencies();
  await _initLoginDependencies();
}

_initHiveService() {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initSplashDependencies() {
  getIt.registerFactory<SplashCubit>(
    () => SplashCubit(getIt<OnboardingBloc>()),
  );
}

_initOnboardingDependencies() {
  getIt.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(),
  );
}

_initDashboardDependencies() async {
  // getIt.registerFactory<DashboardCubit>(
  //   () => DashboardCubit(),
  // );
}

_initRegisterDependencies() async {
  // init local data source
  getIt.registerLazySingleton(
    () => AuthLocalDataSource(getIt<HiveService>()),
  );

  // init local repository
  getIt.registerLazySingleton(
    () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  );

  // register use usecase
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(
      getIt<AuthLocalRepository>(),
    ),
  );

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      registerUseCase: getIt<RegisterUseCase>(),
    ),
  );
}

_initHomeDependencies() async {
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(),
  );
}

_initLoginDependencies() async {
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      getIt<AuthLocalRepository>(),
    ),
  );

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      registerBloc: getIt<RegisterBloc>(),
      homeCubit: getIt<HomeCubit>(),
      loginUseCase: getIt<LoginUseCase>(),
    ),
  );
}
