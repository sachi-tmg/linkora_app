// lib/features/blog/presentation/bloc/blog_event.dart
part of 'blog_bloc.dart';

abstract class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object> get props => [];
}

class FetchLatestBlogs extends BlogEvent {
  final int page;

  const FetchLatestBlogs({required this.page});

  @override
  List<Object> get props => [page];
}
