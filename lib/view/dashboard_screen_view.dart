import 'package:flutter/material.dart';
import 'package:linkora_app/core/common/post_card.dart';
import 'package:linkora_app/viewmodel/dashboard_viewmodel.dart';
import 'package:provider/provider.dart';

class DashboardScreenView extends StatefulWidget {
  const DashboardScreenView({super.key});

  @override
  State<DashboardScreenView> createState() => _DashboardScreenViewState();
}

class _DashboardScreenViewState extends State<DashboardScreenView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardViewModel()..fetchPosts(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Dashboard",
              style: TextStyle(
                fontSize: 26,
                color: Colors.black, // Ensure the text is black
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              iconSize: 30.0,
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<DashboardViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.posts.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      itemCount: viewModel.posts.length,
                      itemBuilder: (context, index) {
                        return PostCard(post: viewModel.posts[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
