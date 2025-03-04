import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:linkora_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:linkora_app/core/network/api_service.dart';
import 'package:linkora_app/core/network/hive_service.dart';
import 'package:linkora_app/features/auth/data/data_source/local_datasource/auth_local_data_source.dart';
import 'package:linkora_app/features/auth/data/data_source/remote_datasource/auth_remote_data_source.dart';
import 'package:linkora_app/features/auth/data/repository/auth_local_repository/auth_local_repository.dart';
import 'package:linkora_app/features/auth/data/repository/auth_remote_repository/auth_remote_repository.dart';
import 'package:linkora_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:linkora_app/features/auth/domain/use_case/register_usecase.dart';
import 'package:linkora_app/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:linkora_app/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:linkora_app/features/blog/data/data_source/remote_datasource/blog_remote_data_source.dart';
import 'package:linkora_app/features/blog/data/repository/blog_remote_repository.dart';
import 'package:linkora_app/features/blog/domain/repository/blog_repository.dart';
import 'package:linkora_app/features/blog/domain/use_case/create_blog_usecase.dart';
import 'package:linkora_app/features/blog/domain/use_case/get_all_blog_usecase.dart';
import 'package:linkora_app/features/blog/domain/use_case/upload_blog_banner_usecase.dart';
import 'package:linkora_app/features/blog/presentation/view_model/editor/create_blog_bloc.dart';
import 'package:linkora_app/features/blog/presentation/view_model/view_blog/blog_bloc.dart';
import 'package:linkora_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:linkora_app/features/onboarding/presentation/view_model/onboarding_bloc.dart';
import 'package:linkora_app/features/regular_user/data/data_source/remote_datasource/regular_user_remote_data_source.dart';
import 'package:linkora_app/features/regular_user/data/repository/regular_user_remote_repository/regular_user_remote_repository.dart';
import 'package:linkora_app/features/regular_user/domain/respository/regular_user_repository.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/get_regular_user_usecase.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/update_regular_user_usecase.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/upload_profile_picture_usecase.dart';
import 'package:linkora_app/features/regular_user/presentation/view_model/profile_bloc.dart';
import 'package:linkora_app/features/splash/presentation/view_model/splash_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initApiService();
  await _initSharedPreferences();
  await _initSplashDependencies();
  await _initOnboardingDependencies();
  await _initHomeDependencies();
  await _initImageDependencies();
  await _initDashboardDependencies();
  await _initRegisterDependencies();
  await _initLoginDependencies();
  await _initRegularUserDependencies();

  await _initBlogDependencies();
}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

_initApiService() {
  getIt.registerLazySingleton<Dio>(
    () => ApiService(Dio()).dio,
  );
}

_initHiveService() {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initRegisterDependencies() async {
  // init local data source
  getIt.registerLazySingleton(
    () => AuthLocalDataSource(getIt<HiveService>()),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<Dio>()),
  );

  // init local repository
  getIt.registerLazySingleton(
    () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  );

  getIt.registerLazySingleton(
    () => AuthRemoteRepository(getIt<AuthRemoteDataSource>()),
  );

  // register use usecase
  // getIt.registerLazySingleton<RegisterUseCase>(
  //   () => RegisterUseCase(
  //     getIt<AuthLocalRepository>(),
  //   ),
  // );

  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(
      getIt<AuthRemoteRepository>(),
    ),
  );

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      registerUseCase: getIt<RegisterUseCase>(),
    ),
  );
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

_initRegularUserDependencies() async {
  // Remote Data Dource
  // getIt.registerLazySingleton<RegularUserRemoteDataSource>(
  //   () => RegularUserRemoteDataSource(
  //     getIt<Dio>(),
  //     getIt<TokenSharedPrefs>(),
  //   ),
  // );

  // Repository
  getIt.registerLazySingleton<IRegularUserRepository>(
    () => RegularUserRemoteRepository(
        getIt<RegularUserRemoteDataSource>()), // Pass positional argument
  );

  // Usecases
  getIt.registerLazySingleton<GetRegularUserUseCase>(
    () => GetRegularUserUseCase(
        getIt<IRegularUserRepository>()), // Pass positional argument
  );

  getIt.registerLazySingleton<UploadProfilePictureUsecase>(
    () => UploadProfilePictureUsecase(
        getIt<IRegularUserRepository>()), // Pass positional argument
  );

  getIt.registerLazySingleton<UpdateRegularUserUseCase>(
    () => UpdateRegularUserUseCase(
        getIt<IRegularUserRepository>()), // Pass positional argument
  );

  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(
        getRegularUserUseCase: getIt<GetRegularUserUseCase>(),
        updateRegularUserUseCase: getIt<UpdateRegularUserUseCase>(),
        uploadProfilePictureUseCase: getIt<UploadProfilePictureUsecase>(),
        tokenSharedPrefs: getIt<TokenSharedPrefs>()),
  );
}

_initHomeDependencies() async {
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(),
  );
}

_initBlogDependencies() async {
  // Local Data Source
  // getIt.registerFactory<BlogLocalDataSource>(
  //     () => BlogLocalDataSource(hiveService: getIt<HiveService>()));

  // Remote Data Dource
  getIt.registerLazySingleton<BlogRemoteDataSource>(
    () => BlogRemoteDataSource(
      dio: getIt<Dio>(),
      tokenSharedPrefs: getIt<TokenSharedPrefs>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<IBlogRepository>(
    () => BlogRepositoryImpl(getIt<Dio>(), getIt<TokenSharedPrefs>(),
        getIt<BlogRemoteDataSource>()), // Pass positional argument
  );

  // Usecases
  getIt.registerLazySingleton<GetLatestBlogsUseCase>(
    () => GetLatestBlogsUseCase(
        getIt<IBlogRepository>()), // Pass positional argument
  );

  // Bloc
  getIt.registerFactory<BlogBloc>(
    () => BlogBloc(
      getLatestBlogsUseCase: getIt<GetLatestBlogsUseCase>(),
    ),
  );

  getIt.registerLazySingleton<UploadBlogBannerUsecase>(
    () => UploadBlogBannerUsecase(
      getIt(),
    ),
  );

  getIt.registerLazySingleton<CreateBlogUseCase>(
    () => CreateBlogUseCase(
      repository: getIt(),
    ), // Pass positional argument
  );

  getIt.registerFactory<CreateBlogBloc>(
    () => CreateBlogBloc(
      createBlogUseCase: getIt<CreateBlogUseCase>(),
      blogBannerUseCase: getIt<UploadBlogBannerUsecase>(),
    ),
  );
}

_initImageDependencies() async {
  // init local data source
  // getIt.registerLazySingleton(
  //   () => AuthLocalDataSource(getIt<HiveService>()),
  // );

  getIt.registerLazySingleton<RegularUserRemoteDataSource>(
    () => RegularUserRemoteDataSource(getIt<Dio>(), getIt<TokenSharedPrefs>()),
  );

  // init local repository
  // getIt.registerLazySingleton(
  //   () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  // );

  getIt.registerLazySingleton(
    () => RegularUserRemoteRepository(getIt<RegularUserRemoteDataSource>()),
  );

  // register use usecase
  // getIt.registerLazySingleton<RegisterUseCase>(
  //   () => RegisterUseCase(
  //     getIt<AuthLocalRepository>(),
  //   ),
  // );

  // getIt.registerLazySingleton<RegularUserUsecase>(
  //   () => RegularUserUsecase(
  //     getIt<RegularUserRemoteRepository>(),
  //   ),
  // );

  // getIt.registerLazySingleton<UploadImageUsecaseP>(
  //   () => UploadImageUsecaseP(
  //     getIt<RegularUserRemoteRepository>(),
  //   ),
  // );

  // getIt.registerFactory<ImageBloc>(
  //   () => ImageBloc(
  //     homeCubit: getIt<HomeCubit>(),
  //     regularUserUsecase: getIt<RegularUserUsecase>(),
  //     uploadImageUsecaseP: getIt<UploadImageUsecaseP>(),
  //   ),
  // );
}

_initLoginDependencies() async {
  getIt.registerLazySingleton<TokenSharedPrefs>(
    () => TokenSharedPrefs(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      getIt<AuthRemoteRepository>(),
      getIt<TokenSharedPrefs>(),
    ),
  );

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      blogBlog: getIt<BlogBloc>(),
      registerBloc: getIt<RegisterBloc>(),
      // homeCubit: getIt<HomeCubit>(),
      // imagebloc: getIt<ImageBloc>(),
      loginUseCase: getIt<LoginUseCase>(),
      tokenSharedPrefs: getIt<TokenSharedPrefs>(),
    ),
  );
}
