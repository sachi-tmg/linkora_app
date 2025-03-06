import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/domain/use_case/get_all_blog_usecase.dart';
import 'package:linkora_app/features/blog/domain/use_case/get_blog_usecase.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/delete_blog_usecase.dart';
import 'package:linkora_app/features/regular_user/domain/use_case/like_blog_usecase.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final GetLatestBlogsUseCase _getLatestBlogsUseCase;
  final GetBlogUseCase _getBlogUseCase;
  final DeleteBlogUseCase _deleteBlogUseCase;
  final LikeBlogUseCase _likeBlogUseCase;

  BlogBloc({
    required GetLatestBlogsUseCase getLatestBlogsUseCase,
    required GetBlogUseCase getBlogUseCase,
    required DeleteBlogUseCase deleteBlogUseCase,
    required LikeBlogUseCase likeBlogUseCase,
  })  : _getLatestBlogsUseCase = getLatestBlogsUseCase,
        _getBlogUseCase = getBlogUseCase,
        _deleteBlogUseCase = deleteBlogUseCase,
        _likeBlogUseCase = likeBlogUseCase,
        super(BlogInitial()) {
    on<FetchLatestBlogs>(_onFetchLatestBlogs);
    on<FetchBlogById>(_onFetchBlogById);
    on<DeleteBlog>(_onDeleteBlog);
    on<LikeBlog>(_onLikeBlog);
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

  Future<void> _onDeleteBlog(DeleteBlog event, Emitter<BlogState> emit) async {
    emit(BlogLoading()); // Show loading state while deleting

    final result = await _deleteBlogUseCase(event.blogId);
    result.fold(
      (failure) {
        emit(BlogError(
            message: failure.message)); // Show error if deletion fails
      },
      (successMessage) {
        emit(BlogDeleted(message: successMessage)); // Show success message
      },
    );
  }

  Future<void> _onLikeBlog(LikeBlog event, Emitter<BlogState> emit) async {
    print("Fetching blog in bloc with ID in bloc: ${event.id}");
    final result = await _likeBlogUseCase(LikeBlogParams(
      id: event.id,
      isLikedByUser: event.isLikedByUser,
    ));

    result.fold(
      (failure) {
        print("Like failed: ${failure.message}");
        emit(BlogError(message: failure.message));
      },
      (success) {
        print("Blog liked: ID=${event.id}, isLiked=$success");
        emit(BlogLiked(id: event.id, isLiked: success));
      },
    );
  }
}
