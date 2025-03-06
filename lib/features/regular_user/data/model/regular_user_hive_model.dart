import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:linkora_app/features/regular_user/domain/entity/regular_user_entity.dart';

part 'regular_user_hive_model.g.dart';

@HiveType(typeId: 2) // Ensure this ID is unique across Hive models
class RegularUserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String? username;

  @HiveField(2)
  final String? fullName;

  @HiveField(3)
  final String profilePicture;

  @HiveField(4)
  final String? bio;

  @HiveField(5)
  final String socialLinks; // Stored as JSON String

  @HiveField(6)
  final int totalPosts;

  @HiveField(7)
  final int totalReads;

  @HiveField(8)
  final List<String> blogs;

  @HiveField(9)
  final String? dateCreated; // Stored as String

  const RegularUserHiveModel({
    this.userId,
    this.username,
    this.fullName,
    required this.profilePicture,
    this.bio,
    required this.socialLinks,
    required this.totalPosts,
    required this.totalReads,
    required this.blogs,
    this.dateCreated,
  });

  // Convert from RegularUserEntity
  factory RegularUserHiveModel.fromEntity(RegularUserEntity entity) {
    return RegularUserHiveModel(
      userId: entity.userId,
      username: entity.username,
      fullName: entity.fullName,
      profilePicture: entity.profilePicture,
      bio: entity.bio,
      socialLinks: jsonEncode(entity.socialLinks), // Convert Map to JSON String
      totalPosts: entity.totalPosts,
      totalReads: entity.totalReads,
      blogs: entity.blogs,
      dateCreated:
          entity.dateCreated?.toIso8601String(), // Convert DateTime to String
    );
  }

  // Convert to RegularUserEntity
  RegularUserEntity toEntity() {
    return RegularUserEntity(
      userId: userId,
      username: username,
      fullName: fullName,
      profilePicture: profilePicture,
      bio: bio,
      socialLinks: jsonDecode(socialLinks), // Convert JSON String back to Map
      totalPosts: totalPosts,
      totalReads: totalReads,
      blogs: blogs,
      dateCreated: dateCreated != null
          ? DateTime.tryParse(dateCreated!)
          : null, // Convert String back to DateTime
    );
  }

  @override
  List<Object?> get props => [
        userId,
        username,
        fullName,
        profilePicture,
        bio,
        socialLinks,
        totalPosts,
        totalReads,
        blogs,
        dateCreated,
      ];
}
