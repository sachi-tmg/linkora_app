import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/features/regular_user/domain/entity/regular_user_entity.dart';

void main() {
  group('RegularUserEntity', () {
    test('should correctly create a RegularUserEntity from JSON', () {
      // Arrange: Create a mock JSON object
      final Map<String, dynamic> json = {
        'user': {
          '_id': 'user123',
          'username': 'testuser',
          'fullName': 'Test User',
          'regularUser': {
            'profilePicture': 'https://link.to/profile_picture',
            'bio': 'This is a bio.',
            'social_links': {
              'youtube': 'https://youtube.com/testuser',
              'instagram': 'https://instagram.com/testuser',
              'facebook': 'https://facebook.com/testuser',
              'twitter': 'https://twitter.com/testuser',
              'github': 'https://github.com/testuser',
              'website': 'https://testuser.com',
            },
            'account_info': {
              'total_posts': 100,
              'total_reads': 500,
            },
            'blogs': ['blog1', 'blog2'],
            'dateCreated': '2022-01-01T00:00:00.000Z',
          },
        }
      };

      // Act: Convert the JSON into a RegularUserEntity using the fromJson factory
      final regularUser = RegularUserEntity.fromJson(json);

      // Assert: Verify that the RegularUserEntity has the expected values
      expect(regularUser.userId, 'user123');
      expect(regularUser.username, 'testuser');
      expect(regularUser.fullName, 'Test User');
      expect(regularUser.profilePicture, 'https://link.to/profile_picture');
      expect(regularUser.bio, 'This is a bio.');
      expect(
          regularUser.socialLinks['youtube'], 'https://youtube.com/testuser');
      expect(regularUser.socialLinks['instagram'],
          'https://instagram.com/testuser');
      expect(regularUser.totalPosts, 100);
      expect(regularUser.totalReads, 500);
      expect(regularUser.blogs, ['blog1', 'blog2']);
      expect(
          regularUser.dateCreated, DateTime.parse('2022-01-01T00:00:00.000Z'));
    });

    test('should handle missing fields and use default values', () {
      // Arrange: Create a JSON object with missing fields
      final Map<String, dynamic> json = {
        'user': {
          '_id': 'user123',
          'username': 'testuser',
          'regularUser': {
            'profilePicture': 'https://link.to/profile_picture',
            'account_info': {},
            'blogs': [],
            'dateCreated': null,
          }
        }
      };

      final regularUser = RegularUserEntity.fromJson(json);

      expect(regularUser.userId, 'user123');
      expect(regularUser.username, 'testuser');
      expect(regularUser.profilePicture, 'https://link.to/profile_picture');
      expect(regularUser.bio, '');
      expect(regularUser.socialLinks['youtube'], '');
      expect(regularUser.socialLinks['instagram'], '');
      expect(regularUser.socialLinks['facebook'], '');
      expect(regularUser.socialLinks['twitter'], '');
      expect(regularUser.socialLinks['github'], '');
      expect(regularUser.socialLinks['website'], '');
      expect(regularUser.totalPosts, 0);
      expect(regularUser.totalReads, 0);
      expect(regularUser.blogs, []);
      expect(regularUser.dateCreated, null);
    });
  });
}
