import 'dart:io';

import 'package:linkora_app/core/network/hive_service.dart';
import 'package:linkora_app/features/auth/data/data_source/auth_data_source.dart';
import 'package:linkora_app/features/auth/data/model/auth_hive_model.dart';
import 'package:linkora_app/features/auth/domain/entity/auth_entity.dart';

class AuthLocalDataSource implements IAuthDataSource {
  final HiveService _hiveService;

  AuthLocalDataSource(this._hiveService);

  @override
  Future<AuthEntity> getCurrentUser() {
    return Future.value(const AuthEntity(
      userId: "1",
      fullName: "",
      email: "",
      password: "",
      image: null,
      bio: null,
    ));
  }

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      await _hiveService.login(email, password);
      return Future.value("Success");
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> registerUser(AuthEntity user) async {
    try {
      // Convert AuthEntity to AuthHiveModel
      final authHiveModel = AuthHiveModel.fromEntity(user);

      await _hiveService.register(authHiveModel);
      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    throw UnimplementedError();
  }
}
