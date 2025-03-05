import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/use_case/get_all_blog_usecase.dart';
import 'package:linkora_app/features/blog/domain/use_case/get_blog_usecase.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final GetLatestBlogsUseCase _getLatestBlogsUseCase;
  final GetBlogUseCase _getBlogUseCase;

  BlogBloc({
    required GetLatestBlogsUseCase getLatestBlogsUseCase,
    required GetBlogUseCase getBlogUseCase,
  })  : _getLatestBlogsUseCase = getLatestBlogsUseCase,
        _getBlogUseCase = getBlogUseCase,
        super(BlogInitial()) {
    on<FetchLatestBlogs>(_onFetchLatestBlogs);
    on<FetchBlogById>(_onFetchBlogById);
  }

  Future<void> _onFetchLatestBlogs(
      FetchLatestBlogs event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final result = await _getLatestBlogsUseCase(event.page);
    result.fold(
      (failure) {
        emit(BlogError(message: failure.message));
      },
      (blogs) {
        emit(BlogLoaded(blogs: blogs));
      },
    );
  }

  Future<void> _onFetchBlogById(
      FetchBlogById event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    print("Fetching blog in bloc with ID in bloc: ${event.blogId}");
    final result = await _getBlogUseCase(event.blogId);
    result.fold(
      (failure) {
        print("Error fetching blog in bloc: ${failure.message}"); // Debug print
        emit(BlogError(message: failure.message));
      },
      (blog) {
        print("Blog fetched successfully in bloc: $blog"); // Debug print
        emit(BlogDetailLoaded(blog: blog));
      },
    );
  }
}
