import 'package:equatable/equatable.dart';

class BlogEntity extends Equatable {
  final String? blogId;
  final String title;
  final String description;
  final String blogPicture;
  final List<String>? content;
  final bool? draft;
  final Map<String, dynamic> activity;
  final List<String>? tags;
  final DateTime dateCreated;
  final Map<String, dynamic> user;
  final String? profilePicture;

  const BlogEntity({
    this.blogId,
    required this.title,
    required this.description,
    required this.blogPicture,
    this.content,
    this.draft,
    required this.activity,
    this.tags,
    required this.dateCreated,
    required this.user,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
        blogId,
        title,
        description,
        blogPicture,
        content,
        draft,
        activity,
        tags,
        dateCreated,
        user,
        profilePicture,
      ];
}
