// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
// import 'package:linkora_app/features/blog/domain/use_case/search_blog_usecase.dart';

// part 'search_blogs_event.dart';
// part 'search_blogs_state.dart';

// class SearchBlogsBloc extends Bloc<SearchBlogsEvent, SearchBlogsState> {
//   final SearchBlogsUseCase searchBlogsUseCase;
//   List<BlogEntity> blogs = [];

//   SearchBlogsBloc(this.searchBlogsUseCase) : super(SearchBlogsInitial()) {
//     on<SearchBlogsQueryEvent>((event, emit) async {
//       if (event.page == 1) {
//         blogs = [];
//         emit(SearchBlogsLoading());
//       } else {
//         emit(SearchBlogsLoadingMore(blogs));
//       }

//       final result = await searchBlogsUseCase(event.query, page: event.page);
//       result.fold(
//         (failure) => emit(SearchBlogsError(failure.message)),
//         (newBlogs) {
//           blogs.addAll(newBlogs);
//           emit(SearchBlogsLoaded(blogs));
//         },
//       );
//     });
//   }
// }

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/use_case/search_blog_usecase.dart';

part 'search_blogs_event.dart';
part 'search_blogs_state.dart';

class SearchBlogsBloc extends Bloc<SearchBlogsEvent, SearchBlogsState> {
  final SearchBlogsUseCase _searchBlogsUseCase;
  List<BlogEntity> _blogs = [];

  SearchBlogsBloc({required SearchBlogsUseCase searchBlogsUseCase})
      : _searchBlogsUseCase = searchBlogsUseCase,
        super(SearchBlogsInitial()) {
    on<SearchBlogsQueryEvent>(_onSearchBlogsQuery);
  }

  Future<void> _onSearchBlogsQuery(
    SearchBlogsQueryEvent event,
    Emitter<SearchBlogsState> emit,
  ) async {
    if (event.page == 1) {
      _blogs = [];
      emit(SearchBlogsLoading());
    } else {
      emit(SearchBlogsLoadingMore(_blogs));
    }

    final result = await _searchBlogsUseCase(event.query, page: event.page);
    result.fold(
      (failure) => emit(SearchBlogsError(failure.message)),
      (newBlogs) {
        _blogs.addAll(newBlogs);
        emit(SearchBlogsLoaded(_blogs));
      },
    );
  }
}
