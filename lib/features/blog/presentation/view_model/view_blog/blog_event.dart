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

class FetchBlogById extends BlogEvent {
  final String blogId;
  const FetchBlogById({required this.blogId});

  @override
  List<Object> get props => [blogId];
}
