import 'dart:io';

import 'package:linkora_app/features/regular_user/domain/entity/regular_user_entity.dart';

abstract interface class IRegularUserDataSource {
  Future<RegularUserEntity> getRegularUser(String userId);

  Future<void> updateRegularUser(RegularUserEntity regularUser);

  Future<String> uploadProfilePicture(File file);
}
