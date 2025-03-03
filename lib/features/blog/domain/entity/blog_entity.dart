// lib/features/blog/domain/entities/blog_entity.dart
import 'package:equatable/equatable.dart';

class BlogEntity extends Equatable {
  final String blogId;
  final String title;
  final String description;
  final String blogPicture;
  final Map<String, dynamic> activity;
  final List<String> tags;
  final DateTime dateCreated;
  final Map<String, dynamic> user;
  final String? profilePicture;

  const BlogEntity({
    required this.blogId,
    required this.title,
    required this.description,
    required this.blogPicture,
    required this.activity,
    required this.tags,
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
        activity,
        tags,
        dateCreated,
        user,
        profilePicture,
      ];
}
