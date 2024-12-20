import 'package:flutter/material.dart';
import 'package:linkora_app/model/dashboard_model.dart';

class DashboardViewModel extends ChangeNotifier {
  List<Post> posts = [];

  // Fetch posts (you can replace this with real API calls)
  void fetchPosts() {
    // Simulating a network call with mock data
    posts = [
      Post(
        title: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit.",
        tags: ["tag 1", "tag 2"],
        imageUrl: 'assets/images/image1.jpg',
        likes: 10,
      ),
      Post(
        title: "Sed enim nisl",
        content: "Sed adipiscing elit.",
        tags: ["tag 3"],
        imageUrl: 'assets/images/image1.jpg',
        likes: 5,
      ),
      Post(
        title: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit.",
        tags: ["tag 1", "tag 2"],
        imageUrl: 'assets/images/image1.jpg',
        likes: 12,
      ),
      Post(
        title: "Sed enim nisl",
        content: "Sed adipiscing elit.",
        tags: ["tag 3"],
        imageUrl: 'assets/images/image1.jpg',
        likes: 7,
      ),
      Post(
        title: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit.",
        tags: ["tag 1", "tag 2"],
        imageUrl: 'assets/images/image1.jpg',
        likes: 14,
      ),
      Post(
        title: "Sed enim nisl",
        content: "Sed adipiscing elit.",
        tags: ["tag 3"],
        imageUrl: 'assets/images/image1.jpg',
        likes: 9,
      ),
    ];

    notifyListeners(); // Notify the UI to rebuild with the updated posts
  }
}
