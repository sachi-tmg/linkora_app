import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'regular_user_api_model.g.dart';

@JsonSerializable()
class RegularUserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String profilePicture;
  final String? bio;
  final Map<String, String>? social_links;
  final Map<String, int>? account_info;
  final List<String>? blogs;
  final String? dateCreated;
  @JsonKey(ignore: true)
  final String? fullName;

  const RegularUserApiModel({
    this.id,
    required this.profilePicture,
    this.bio,
    this.social_links,
    this.account_info,
    this.blogs,
    this.dateCreated,
    this.fullName,
  });

  /// Custom `fromJson` method to handle potential `null` values safely
  factory RegularUserApiModel.fromJson(Map<String, dynamic> json) {
    return RegularUserApiModel(
      id: json['_id'] as String?,
      profilePicture: json['profilePicture'] ?? '',
      bio: json['bio'] ?? '',
      social_links: (json['social_links'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value ?? ''),
          ) ??
          {},
      account_info: (json['account_info'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value ?? 0),
          ) ??
          {},
      blogs:
          (json['blogs'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      dateCreated: json['dateCreated'],
    );
  }

  Map<String, dynamic> toJson() {
    final json = _$RegularUserApiModelToJson(this);
    json.remove('fullName');
    return json;
  }

  @override
  List<Object?> get props => [
        id,
        profilePicture,
        bio,
        social_links,
        account_info,
        blogs,
        dateCreated,
        fullName,
      ];
}
