import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/presentation/view/blog_detail_view.dart';
import 'package:linkora_app/features/blog/presentation/view_model/view_blog/blog_bloc.dart';
import 'package:linkora_app/features/regular_user/presentation/view_model/profile_bloc.dart';

class ProfileBlogListWidget extends StatelessWidget {
  const ProfileBlogListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.errorMessage != null) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state.blogs != null && state.blogs!.isNotEmpty) {
          return ListView.builder(
            itemCount: state.blogs!.length,
            itemBuilder: (context, index) {
              final blog = state.blogs![index];
              return BlogCard(blog: blog);
            },
          );
        } else {
          return const Center(child: Text('No blogs found'));
        }
      },
    );
  }
}

class BlogCard extends StatelessWidget {
  final BlogEntity blog;

  const BlogCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final blogBloc = context
            .read<BlogBloc>(); // Get the BlogBloc from the current context
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: blogBloc, // Pass the existing BlogBloc to the new route
              child: BlogDetailPage(blogId: blog.blogId!),
            ),
          ),
        );
        if (result == true) {
          blogBloc.add(const FetchLatestBlogs(page: 1));
        }
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Title, Description, Like and Comment Counts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      blog.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Description
                    Text(
                      blog.description,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2, // Limit to 2 lines
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    // Like and Comment Counts
                    Row(
                      children: [
                        Text("${blog.activity['likeCount']} Likes"),
                        const SizedBox(width: 20),
                        Text("${blog.activity['commentCount']} Comments"),
                        const SizedBox(width: 20),
                        Text("${blog.activity['total_reads']} Reads"),
                      ],
                    ),
                  ],
                ),
              ),
              // Blog picture on the right side (if it exists)
              if (blog.blogPicture.isNotEmpty)
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(blog.blogPicture),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
