import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/core/common/snackbar/my_snackbar.dart';
import 'package:linkora_app/features/home/presentation/view/home_view.dart';
import 'package:linkora_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/regular_user_usecase.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final RegularUserUsecase _regularUserUsecase;
  final HomeCubit _homeCubit;
  final UploadImageUsecaseP _uploadImageUsecaseP;

  ImageBloc({
    required RegularUserUsecase regularUserUsecase,
    required UploadImageUsecaseP uploadImageUsecaseP,
    required HomeCubit homeCubit,
  })  : _regularUserUsecase = regularUserUsecase,
        _uploadImageUsecaseP = uploadImageUsecaseP,
        _homeCubit = homeCubit,
        super(ImageState.initial()) {
    on<RegularUser>(_onRegularUserEvent);
    on<LoadImageP>(_onLoadImageP);
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
  }

  Future<void> _onRegularUserEvent(
    RegularUser event,
    Emitter<ImageState> emit,
  ) async {
    debugPrint("Received User ID in Bloc: ${event.userId}");
    emit(state.copyWith(isLoading: true));

    final result = await _regularUserUsecase.call(
      RegularUserUsecaseParams(
        userId: event.userId,
        profilePicture: state.imageName,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        debugPrint("Failure: $failure");
        showMySnackBar(
          context: event.context,
          message: failure.message,
          color: Colors.red,
        );
      },
      (userId) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        add(
          NavigateHomeScreenEvent(
            context: event.context,
            destination: const HomeView(),
          ),
        );
        //_homeCubit.setToken(token);
      },
    );
  }

  Future<void> _onLoadImageP(
    LoadImageP event,
    Emitter<ImageState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _uploadImageUsecaseP.call(
      UploadImageParamsP(file: event.file),
    );

    result.fold(
      (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (r) =>
          emit(state.copyWith(isLoading: false, isSuccess: true, imageName: r)),
    );
  }
}
