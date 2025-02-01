part of 'image_bloc.dart';

sealed class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class NavigateHomeScreenEvent extends ImageEvent {
  final BuildContext context;
  final Widget destination;

  const NavigateHomeScreenEvent({
    required this.context,
    required this.destination,
  });
}

class LoadImageP extends ImageEvent {
  final File file;

  const LoadImageP({
    required this.file,
  });
}

class RegularUser extends ImageEvent {
  final String userId;
  final BuildContext context;
  final String? profilePicture;

  const RegularUser({
    required this.context,
    required this.userId,
    this.profilePicture,
  });
}
