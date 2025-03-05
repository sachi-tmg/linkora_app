import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/features/blog/presentation/view_model/search_blogs/search_blogs_bloc.dart';
import 'package:linkora_app/features/blog/presentation/widget/blog_list_widget.dart';

class SearchBlogsView extends StatefulWidget {
  const SearchBlogsView({super.key});

  @override
  State<SearchBlogsView> createState() => _SearchBlogsViewState();
}

class _SearchBlogsViewState extends State<SearchBlogsView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more blogs when the user reaches the bottom
      _page++;
      context
          .read<SearchBlogsBloc>()
          .add(SearchBlogsQueryEvent(_searchController.text, page: _page));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Search Blogs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search blogs...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (query) {
                _page = 1; // Reset page to 1 for a new search
                context
                    .read<SearchBlogsBloc>()
                    .add(SearchBlogsQueryEvent(query, page: _page));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBlogsBloc, SearchBlogsState>(
              builder: (context, state) {
                if (state is SearchBlogsLoading && _page == 1) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchBlogsError) {
                  return Center(child: Text(state.message));
                } else if (state is SearchBlogsLoaded) {
                  if (state.blogs.isEmpty) {
                    return Center(
                        child: Text(
                            'No blogs found for "${_searchController.text}"'));
                  }
                  return BlogListWidget(
                    blogs: state.blogs,
                    scrollController: _scrollController,
                  );
                } else {
                  return const Center(child: Text('Enter a search query'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
