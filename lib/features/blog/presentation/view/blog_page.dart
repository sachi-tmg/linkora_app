import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/presentation/view_model/view_blog/blog_bloc.dart';
import 'package:linkora_app/features/blog/presentation/widget/blog_list_widget.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  int page = 1; // Track the current page
  List<BlogEntity> blogs = []; // Store all blogs
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    context.read<BlogBloc>().add(FetchLatestBlogs(page: page));
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load next page when close to the bottom
      setState(() {
        page++;
      });
      context.read<BlogBloc>().add(FetchLatestBlogs(page: page));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blogBloc = context.read<BlogBloc>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                page = 1;
                blogs.clear(); // Clear previous blogs on refresh
              });
              blogBloc.add(FetchLatestBlogs(page: page));
            },
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: BlocListener<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogLoaded) {
            setState(() {
              blogs.addAll(state.blogs); // Append new blogs
            });
          }
        },
        child: blogs.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : BlogListWidget(blogs: blogs, scrollController: _scrollController),
      ),
    );
  }
}
