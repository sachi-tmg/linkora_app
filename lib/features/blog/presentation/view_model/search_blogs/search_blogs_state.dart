part of 'search_blogs_bloc.dart';

abstract class SearchBlogsState extends Equatable {
  const SearchBlogsState();

  @override
  List<Object?> get props => [];
}

class SearchBlogsInitial extends SearchBlogsState {}

class SearchBlogsLoading extends SearchBlogsState {}

class SearchBlogsLoadingMore extends SearchBlogsState {
  final List<BlogEntity> blogs;

  const SearchBlogsLoadingMore(this.blogs);

  @override
  List<Object?> get props => [blogs];
}

class SearchBlogsLoaded extends SearchBlogsState {
  final List<BlogEntity> blogs;

  const SearchBlogsLoaded(this.blogs);

  @override
  List<Object?> get props => [blogs];
}

class SearchBlogsError extends SearchBlogsState {
  final String message;

  const SearchBlogsError(this.message);

  @override
  List<Object?> get props => [message];
}
