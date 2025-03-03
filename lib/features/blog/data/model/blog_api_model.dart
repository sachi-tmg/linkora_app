import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';

part 'blog_api_model.g.dart';

@JsonSerializable()
class BlogApiModel extends Equatable {
  @JsonKey(name: 'blog_id')
  final String? blogId;
  final String title;
  @JsonKey(name: 'des')
  final String description;
  final String blogPicture;
  final String? content;
  final bool? draft;
  final Map<String, dynamic> activity;
  final List<String> tags;
  @JsonKey(name: 'dateCreated')
  final DateTime? dateCreated;
  @JsonKey(name: 'userId')
  final Map<String, dynamic> user;
  final String? profilePicture;

  const BlogApiModel({
    this.blogId,
    required this.title,
    required this.description,
    required this.blogPicture,
    this.content,
    this.draft,
    this.activity = const {},
    required this.tags,
    this.dateCreated,
    this.user = const {},
    this.profilePicture,
  });

  // JSON Serialization
  factory BlogApiModel.fromJson(Map<String, dynamic> json) {
    return _$BlogApiModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$BlogApiModelToJson(this);

  // Convert to Entity
  BlogEntity toEntity() {
    return BlogEntity(
      blogId: blogId,
      title: title,
      description: description,
      blogPicture: blogPicture,
      content: content,
      draft: draft,
      activity: activity,
      tags: tags,
      dateCreated: dateCreated ?? DateTime.now(),
      user: user,
      profilePicture: profilePicture,
    );
  }

  // Convert from Entity
  factory BlogApiModel.fromEntity(BlogEntity entity) {
    return BlogApiModel(
      blogId: entity.blogId,
      title: entity.title,
      description: entity.description,
      blogPicture: entity.blogPicture,
      content: entity.content,
      draft: entity.draft,
      activity: entity.activity,
      tags: entity.tags,
      dateCreated: entity.dateCreated,
      user: entity.user,
      profilePicture: entity.profilePicture,
    );
  }

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
