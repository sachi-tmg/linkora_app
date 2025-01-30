import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial());

  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is FetchPostsEvent) {
      yield DashboardLoading();
      try {
        // Simulating a delay and fetching posts (you can replace this with API calls)
        await Future.delayed(const Duration(seconds: 2));
        final posts = [
          'Post 1',
          'Post 2',
          'Post 3',
          'Post 4',
        ]; // Example posts
        yield DashboardLoaded(posts: posts);
      } catch (e) {
        yield DashboardError(message: 'Failed to load posts');
      }
    }
  }
}
