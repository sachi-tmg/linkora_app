// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regular_user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegularUserApiModel _$RegularUserApiModelFromJson(Map<String, dynamic> json) =>
    RegularUserApiModel(
      id: json['_id'] as String?,
      profilePicture: json['profilePicture'] as String,
      bio: json['bio'] as String?,
      social_links: (json['social_links'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      account_info: (json['account_info'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      blogs:
          (json['blogs'] as List<dynamic>?)?.map((e) => e as String).toList(),
      dateCreated: json['dateCreated'] as String?,
    );

Map<String, dynamic> _$RegularUserApiModelToJson(
        RegularUserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'profilePicture': instance.profilePicture,
      'bio': instance.bio,
      'social_links': instance.social_links,
      'account_info': instance.account_info,
      'blogs': instance.blogs,
      'dateCreated': instance.dateCreated,
    };
