part of 'create_blog_bloc.dart';

sealed class CreateBlogEvent extends Equatable {
  const CreateBlogEvent();

  @override
  List<Object> get props => [];
}

class CreateBlogRequested extends CreateBlogEvent {
  final BlogApiModel blog;

  const CreateBlogRequested({required this.blog});

  @override
  List<Object> get props => [blog];
}

class UploadBanner extends CreateBlogEvent {
  final File file;

  const UploadBanner({
    required this.file,
  });

  @override
  List<Object> get props => [file];
}
