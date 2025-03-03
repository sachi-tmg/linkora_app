import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/use_case/get_all_blog_usecase.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final GetLatestBlogsUseCase _getLatestBlogsUseCase;

  BlogBloc({
    required GetLatestBlogsUseCase getLatestBlogsUseCase,
  })  : _getLatestBlogsUseCase = getLatestBlogsUseCase,
        super(BlogInitial()) {
    on<FetchLatestBlogs>(_onFetchLatestBlogs);
  }

  Future<void> _onFetchLatestBlogs(
      FetchLatestBlogs event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final result = await _getLatestBlogsUseCase(event.page);
    result.fold(
      (failure) => emit(BlogError(message: failure.message)),
      (blogs) => emit(BlogLoaded(blogs: blogs)),
    );
  }
}
