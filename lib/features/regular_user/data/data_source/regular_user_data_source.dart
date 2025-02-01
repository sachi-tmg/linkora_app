import 'dart:io';

import 'package:linkora_app/features/regular_user/domain/entity/regular_user_entity.dart';

abstract interface class IRegularDataSource {
  Future<void> regularUser(RegularUserEntity ruser);

  Future<String> uploadProfilePicture(File file);
}
