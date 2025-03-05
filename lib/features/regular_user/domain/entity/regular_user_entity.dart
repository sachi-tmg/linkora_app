class RegularUserEntity {
  final String? userId;
  final String? username;
  final String? fullName;
  final String profilePicture;
  final String? bio;
  final Map<String, String> socialLinks;
  final int totalPosts;
  final int totalReads;
  final List<String> blogs;
  final DateTime? dateCreated;

  RegularUserEntity({
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

  factory RegularUserEntity.fromJson(Map<String, dynamic> json) {
    return RegularUserEntity(
      userId: json['user']?['_id'] as String?,
      username: json['user']?['username'] as String?,
      fullName: json['user']?['fullName'] ?? '',
      profilePicture: json['user']?['regularUser']?['profilePicture'] ?? '',
      bio: json['user']?['regularUser']?['bio'] ?? '',
      socialLinks: {
        'youtube':
            json['user']?['regularUser']?['social_links']?['youtube'] ?? '',
        'instagram':
            json['user']?['regularUser']?['social_links']?['instagram'] ?? '',
        'facebook':
            json['user']?['regularUser']?['social_links']?['facebook'] ?? '',
        'twitter':
            json['user']?['regularUser']?['social_links']?['twitter'] ?? '',
        'github':
            json['user']?['regularUser']?['social_links']?['github'] ?? '',
        'website':
            json['user']?['regularUser']?['social_links']?['website'] ?? '',
      },
      totalPosts:
          json['user']?['regularUser']?['account_info']?['total_posts'] ?? 0,
      totalReads:
          json['user']?['regularUser']?['account_info']?['total_reads'] ?? 0,
      blogs: (json['user']?['regularUser']?['blogs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      dateCreated: json['user']?['regularUser']?['dateCreated'] != null
          ? DateTime.tryParse(json['user']!['regularUser']!['dateCreated'])
          : null,
    );
  }
}
