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

class DeleteBlog extends BlogEvent {
  final String blogId;

  const DeleteBlog({required this.blogId});

  @override
  List<Object> get props => [blogId];
}

class LikeBlog extends BlogEvent {
  final String id;
  final bool isLikedByUser;

  const LikeBlog({required this.id, required this.isLikedByUser});

  @override
  List<Object> get props => [id, isLikedByUser];
}
