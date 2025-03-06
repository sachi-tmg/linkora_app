import 'package:equatable/equatable.dart';
import 'package:linkora_app/features/blog/data/model/blog_api_model.dart';

class BlogEntity extends Equatable {
  final String? id;
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
    this.id,
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
        id,
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

extension BlogEntityToApiModel on BlogEntity {
  BlogApiModel toApiModel() {
    return BlogApiModel(
      id: id,
      blogId: blogId,
      title: title,
      description: description,
      blogPicture: blogPicture,
      content: content,
      draft: draft,
      activity: activity,
      tags: tags,
      dateCreated: dateCreated,
      user: user,
      profilePicture: profilePicture,
    );
  }
}
