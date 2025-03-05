part of 'search_blogs_bloc.dart';

abstract class SearchBlogsEvent extends Equatable {
  const SearchBlogsEvent();

  @override
  List<Object?> get props => [];
}

class SearchBlogsQueryEvent extends SearchBlogsEvent {
  final String query;
  final int page;

  const SearchBlogsQueryEvent(this.query, {this.page = 1});

  @override
  List<Object?> get props => [query, page];
}
