import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/core/common/snackbar/my_snackbar.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/presentation/view_model/view_blog/blog_bloc.dart';
import 'package:linkora_app/features/blog/presentation/widget/blog_list_widget.dart';
import 'package:proximity_sensor/proximity_sensor.dart'; // Import proximity sensor

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  int page = 1; // Track the current page
  List<BlogEntity> blogs = []; // Store all blogs
  late ScrollController _scrollController;
  late Stream<int> _proximityStream; // Stream to listen to proximity sensor

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    context.read<BlogBloc>().add(FetchLatestBlogs(page: page));

    // Initialize the proximity sensor stream
    _proximityStream = ProximitySensor.events;
    _proximityStream.listen((event) {
      // event == 1 means an object is near the sensor
      if (event == 1) {
        _refreshContent(); // Trigger refresh if proximity sensor detects an object
      }
    });
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

  void _refreshContent() {
    final blogBloc = context.read<BlogBloc>();

    // Show custom Snackbar indicating that refresh is triggered
    showMySnackBar(
      context: context,
      message: "Refreshing blogs...",
      color: Colors.blue, // You can customize the color as needed
    );

    setState(() {
      page = 1;
      blogs.clear(); // Clear previous blogs on refresh
    });

    blogBloc.add(FetchLatestBlogs(page: page)); // Trigger a refresh
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Home',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _refreshContent(); // Trigger refresh on manual button press
            },
          ),
        ],
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogLoaded) {
            setState(() {
              blogs.addAll(state.blogs); // Append new blogs
            });
          }
        },
        child: Column(
          children: [
            Expanded(
              child: blogs.isEmpty
                  ? const Center(child: Text('No blogs published yet.'))
                  : BlogListWidget(
                      blogs: blogs, scrollController: _scrollController),
            ),
          ],
        ),
      ),
    );
  }
}
