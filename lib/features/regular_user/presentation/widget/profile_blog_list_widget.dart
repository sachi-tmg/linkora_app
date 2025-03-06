import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/app/di/di.dart';
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
          // Use ListView for both phones and tablets
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.blogs!.length,
            itemBuilder: (context, index) {
              final blog = state.blogs![index];
              return ProfileBlogCard(blog: blog);
            },
          );
        } else {
          return const Center(child: Text('No blogs found'));
        }
      },
    );
  }
}

class ProfileBlogCard extends StatelessWidget {
  final BlogEntity blog;

  const ProfileBlogCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return GestureDetector(
      onTap: () async {
        final blogBloc = getIt<BlogBloc>();
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: blogBloc,
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
        elevation: 4, // Add elevation for a better look
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: SizedBox(
          width: double.infinity, // Make the card cover the full width
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side: Title, Description, Like and Comment Counts
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                        maxLines:
                            isTablet ? 3 : 2, // Adjust max lines for tablets
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      // Like and Read Counts
                      Row(
                        children: [
                          Text("${blog.activity['likeCount']} Likes"),
                          const SizedBox(width: 20),
                          Text("${blog.activity['total_reads']} Reads"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Delete button
                      TextButton(
                        onPressed: () {
                          final blogBloc = getIt<BlogBloc>();
                          blogBloc.add(DeleteBlog(blogId: blog.blogId!));
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red, // Sets text color to red
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ),
                // Blog picture on the right side (if it exists)
                if (blog.blogPicture.isNotEmpty)
                  Container(
                    width: isTablet ? 150 : 100, // Adjust width for tablets
                    height: isTablet ? 150 : 100, // Adjust height for tablets
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
      ),
    );
  }
}
