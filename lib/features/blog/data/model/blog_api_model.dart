// lib/features/blog/data/models/blog_api_model.dart
import 'package:equatable/equatable.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';

class BlogApiModel extends Equatable {
  final String blogId;
  final String title;
  final String description;
  final String blogPicture;
  final Map<String, dynamic> activity;
  final List<String> tags;
  final DateTime dateCreated;
  final Map<String, dynamic> user;
  final String? profilePicture;

  const BlogApiModel({
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

  factory BlogApiModel.fromJson(Map<String, dynamic> json) {
    return BlogApiModel(
      blogId: json['blog_id'],
      title: json['title'],
      description: json['des'],
      blogPicture: json['blogPicture'],
      activity: json['activity'],
      tags: List<String>.from(json['tags']),
      dateCreated: DateTime.parse(json['dateCreated']),
      user: json['userId'],
      profilePicture: json['profilePicture'],
    );
  }

  BlogEntity toEntity() {
    return BlogEntity(
      blogId: blogId,
      title: title,
      description: description,
      blogPicture: blogPicture,
      activity: activity,
      tags: tags,
      dateCreated: dateCreated,
      user: user,
      profilePicture: profilePicture,
    );
  }

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
