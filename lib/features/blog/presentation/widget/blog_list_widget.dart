import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';
import 'package:linkora_app/features/blog/presentation/view/blog_detail_view.dart';
import 'package:linkora_app/features/blog/presentation/view_model/search_blogs/search_blogs_bloc.dart'; // Add this import
import 'package:linkora_app/features/blog/presentation/view_model/view_blog/blog_bloc.dart';

class BlogListWidget extends StatelessWidget {
  final List<BlogEntity> blogs;
  final ScrollController scrollController;

  const BlogListWidget({
    super.key,
    required this.blogs,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: blogs.length + 1, // Add 1 for the loading indicator
      itemBuilder: (context, index) {
        if (index < blogs.length) {
          return BlogCard(blog: blogs[index]);
        } else {
          return BlocBuilder<SearchBlogsBloc, SearchBlogsState>(
            builder: (context, state) {
              if (state is SearchBlogsLoadingMore) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return Container();
              }
            },
          );
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
              // Left side: Title, Description, and Profile Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture, Full Name, and Username
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: blog.profilePicture != null
                              ? NetworkImage(blog.profilePicture!)
                              : null,
                          child: blog.profilePicture == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              blog.user['fullName'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              blog.user['username'],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    // Like and Comment Buttons
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.thumb_up),
                          onPressed: () {
                            // Handle like action
                          },
                        ),
                        Text("${blog.activity['likeCount']} Likes"),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(Icons.comment),
                          onPressed: () {
                            // Handle comment action
                          },
                        ),
                        Text("${blog.activity['commentCount']} Comments"),
                      ],
                    ),
                  ],
                ),
              ),
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
