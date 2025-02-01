part of 'image_bloc.dart';

class ImageState {
  final bool isLoading;
  final bool isSuccess;
  final String? imageName;

  ImageState({
    required this.isLoading,
    required this.isSuccess,
    this.imageName,
  });

  ImageState.initial()
      : isLoading = false,
        isSuccess = false,
        imageName = null;

  ImageState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? imageName,
  }) {
    return ImageState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      imageName: imageName ?? this.imageName,
    );
  }

  List<Object?> get props => [isLoading, isSuccess, imageName];
}
