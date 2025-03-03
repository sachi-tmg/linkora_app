// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogApiModel _$BlogApiModelFromJson(Map<String, dynamic> json) => BlogApiModel(
      blogId: json['blog_id'] as String?,
      title: json['title'] as String,
      description: json['des'] as String,
      blogPicture: json['blogPicture'] as String,
      content: json['content'] as String?,
      draft: json['draft'] as bool?,
      activity: json['activity'] as Map<String, dynamic>? ?? const {},
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
      user: json['userId'] as Map<String, dynamic>? ?? const {},
      profilePicture: json['profilePicture'] as String?,
    );

Map<String, dynamic> _$BlogApiModelToJson(BlogApiModel instance) =>
    <String, dynamic>{
      'blog_id': instance.blogId,
      'title': instance.title,
      'des': instance.description,
      'blogPicture': instance.blogPicture,
      'content': instance.content,
      'draft': instance.draft,
      'activity': instance.activity,
      'tags': instance.tags,
      'dateCreated': instance.dateCreated?.toIso8601String(),
      'userId': instance.user,
      'profilePicture': instance.profilePicture,
    };
