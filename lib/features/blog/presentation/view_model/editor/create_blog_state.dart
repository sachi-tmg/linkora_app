part of 'create_blog_bloc.dart';

sealed class CreateBlogState extends Equatable {
  final String? imageName;

  const CreateBlogState({this.imageName});

  @override
  List<Object> get props => [imageName ?? ''];
}

final class CreateBlogInitial extends CreateBlogState {
  const CreateBlogInitial({super.imageName});
}

class BlogLoading extends CreateBlogState {
  const BlogLoading({super.imageName});
}

class BlogCreated extends CreateBlogState {
  final String blogId;

  const BlogCreated({required this.blogId, super.imageName});

  @override
  List<Object> get props => [blogId, imageName ?? ''];
}

class BlogError extends CreateBlogState {
  final String message;

  const BlogError({required this.message, super.imageName});

  @override
  List<Object> get props => [message, imageName ?? ''];
}
