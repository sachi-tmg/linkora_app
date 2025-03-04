part of 'create_blog_bloc.dart';

sealed class CreateBlogState extends Equatable {
  final String imageName;

  const CreateBlogState({required this.imageName});

  @override
  List<Object> get props => [imageName];
}

final class CreateBlogInitial extends CreateBlogState {
  const CreateBlogInitial({required super.imageName});
}

class BlogLoading extends CreateBlogState {
  const BlogLoading({required super.imageName});
}

class BlogCreated extends CreateBlogState {
  final String blogId;

  const BlogCreated({required this.blogId, required super.imageName});

  @override
  List<Object> get props => [blogId, imageName];
}

class BlogError extends CreateBlogState {
  final String message;

  const BlogError({required this.message, required super.imageName});

  @override
  List<Object> get props => [message, imageName];
}
