import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:linkora_app/features/blog/presentation/view_model/view_blog/blog_bloc.dart';

class BlogDetailPage extends StatefulWidget {
  final String blogId;

  const BlogDetailPage({super.key, required this.blogId});

  @override
  _BlogDetailPageState createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  bool showCommentSection = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(FetchBlogById(blogId: widget.blogId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // Pass `true` when back is pressed
          },
        ),
      ),
      body: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BlogError) {
            return Center(child: Text("Error: ${state.message}"));
          } else if (state is BlogDetailLoaded) {
            final blog = state.blog;

            // Convert dateCreated to a readable format (YYYY-MM-DD)
            String formattedDate =
                DateFormat('yyyy-MM-dd').format(blog.dateCreated);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "@${blog.user['username']}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Blog Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      blog.blogPicture,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Blog Title
                  Text(
                    blog.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Blog Date
                  Text(
                    "Published on: $formattedDate",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Blog Content
                  blog.content?.isEmpty ?? true
                      ? const Text("No content available.")
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: blog.content!
                              .map(
                                (paragraph) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    paragraph,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                  const SizedBox(height: 15),

                  // Tags
                  if (blog.tags != null && blog.tags!.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      children: blog.tags!
                          .map(
                            (tag) => Chip(
                              label: Text(
                                "#$tag",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                          )
                          .toList(),
                    ),

                  const SizedBox(height: 15),

                  // Like and Comment Buttons
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.thumb_up),
                        onPressed: () {
                          // Handle like functionality
                        },
                      ),
                      Text("${blog.activity['likeCount']} Likes"),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.comment),
                        onPressed: () {
                          setState(() {
                            showCommentSection = !showCommentSection;
                          });
                        },
                      ),
                      Text("${blog.activity['commentCount']} Comments"),
                    ],
                  ),

                  // Comment Section (Only Visible When Clicked)
                  if (showCommentSection)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Write a comment:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: "Enter your comment...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Handle comment submission
                          },
                          child: const Text("Post Comment"),
                        ),
                      ],
                    ),
                ],
              ),
            );
          }
          return const Center(child: Text("Fetching blog details..."));
        },
      ),
    );
  }
}
