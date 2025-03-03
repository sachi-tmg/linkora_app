// // lib/features/blog/presentation/pages/blog_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:linkora_app/features/blog/domain/repository/blog_repository.dart';
// import 'package:linkora_app/features/blog/domain/use_case/get_all_blog_usecase.dart';
// import 'package:linkora_app/features/blog/presentation/view_model/blog_bloc.dart';
// import 'package:linkora_app/features/blog/presentation/widget/blog_list_widget.dart';

// class BlogPage extends StatelessWidget {
//   const BlogPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Latest Blogs'),
//       ),
//       body: BlocProvider(
//         create: (context) => BlogBloc(
//           getLatestBlogsUseCase: GetLatestBlogsUseCase(
//             context.read<BlogRepository>(),
//           ),
//         )..add(const FetchLatestBlogs(page: 1)),
//         child: const BlogListWidget(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/features/blog/domain/repository/blog_repository.dart';
import 'package:linkora_app/features/blog/domain/use_case/get_all_blog_usecase.dart';
import 'package:linkora_app/features/blog/presentation/view_model/blog_bloc.dart';
import 'package:linkora_app/features/blog/presentation/widget/blog_list_widget.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => BlogBloc(
          getLatestBlogsUseCase: GetLatestBlogsUseCase(
            context.read<BlogRepository>(),
          ),
        )..add(
            const FetchLatestBlogs(page: 1)), // Trigger FetchLatestBlogs event
        child: const BlogListWidget(),
      ),
    );
  }
}
