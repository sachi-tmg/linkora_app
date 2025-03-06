import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';

part 'blog_hive_model.g.dart';

@HiveType(typeId: 1)
class BlogHiveModel extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? blogId;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final String blogPicture;
  @HiveField(5)
  final List<String>? content;
  @HiveField(6)
  final bool? draft;
  @HiveField(7)
  final Map<String, dynamic> activity;
  @HiveField(8)
  final List<String>? tags;
  @HiveField(9)
  final DateTime? dateCreated;
  @HiveField(10)
  final Map<String, dynamic> user;
  @HiveField(11)
  final String? profilePicture;

  const BlogHiveModel({
    this.id,
    this.blogId,
    required this.title,
    required this.description,
    required this.blogPicture,
    this.content,
    this.draft,
    this.activity = const {},
    this.tags = const [],
    this.dateCreated,
    this.user = const {},
    this.profilePicture,
  });

  factory BlogHiveModel.fromEntity(BlogEntity entity) {
    return BlogHiveModel(
      id: entity.id,
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

  BlogEntity toEntity() {
    return BlogEntity(
      id: id,
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
