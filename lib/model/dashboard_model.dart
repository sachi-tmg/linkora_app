class Post {
  final String title;
  final String content;
  final List<String> tags;
  final String imageUrl;
  final int likes;

  Post({
    required this.title,
    required this.content,
    required this.tags,
    required this.imageUrl,
    required this.likes,
  });
}
