part of 'blog_bloc.dart';

abstract class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object> get props => [];
}

class BlogInitial extends BlogState {}

class BlogLoading extends BlogState {}

class BlogLoaded extends BlogState {
  final List<BlogEntity> blogs;

  const BlogLoaded({required this.blogs});

  @override
  List<Object> get props => [blogs];
}

class BlogDetailLoaded extends BlogState {
  final BlogEntity blog;
  const BlogDetailLoaded({required this.blog});

  @override
  List<Object> get props => [blog];
}

class BlogError extends BlogState {
  final String message;

  const BlogError({required this.message});

  @override
  List<Object> get props => [message];
}
