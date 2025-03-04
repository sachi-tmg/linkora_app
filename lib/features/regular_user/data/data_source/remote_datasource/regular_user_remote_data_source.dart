import 'dart:io';

import 'package:dio/dio.dart';
import 'package:linkora_app/app/constants/api_endpoints.dart';
import 'package:linkora_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:linkora_app/features/regular_user/data/data_source/regular_user_data_source.dart';
import 'package:linkora_app/features/regular_user/domain/entity/regular_user_entity.dart';

class RegularUserRemoteDataSource implements IRegularUserDataSource {
  final Dio _dio;
  final TokenSharedPrefs _tokenSharedPrefs;

  RegularUserRemoteDataSource(this._dio, this._tokenSharedPrefs);

  Future<String?> _getToken() async {
    final tokenResult = await _tokenSharedPrefs.getToken();
    return tokenResult.getOrElse(() => '');
  }

  Future<String?> _getUsername() async {
    final userNameResult = await _tokenSharedPrefs.getUsername();
    return userNameResult.getOrElse(() => '');
  }

  @override
  Future<String> uploadProfilePicture(File file) async {
    try {
      String fileName = file.path;
      FormData formData = FormData.fromMap({
        'profilePicture':
            await MultipartFile.fromFile(file.path, filename: fileName),
      });

      Response response = await _dio.post(
        ApiEndpoints.uploadImage,
        data: formData,
      );

      if (response.statusCode == 200) {
        final imageName = response.data['data'];
        return imageName;
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.message}");
    } catch (e) {
      throw Exception("Unknown error: ${e.toString()}");
    }
  }

  @override
  Future<RegularUserEntity> getRegularUser(String username) async {
    try {
      final username = await _getUsername();
      print("username: $username");
      Response response = await _dio.post(
        ApiEndpoints.getRegularUser,
        data: {"username": username},
      );

      if (response.statusCode == 200) {
        return RegularUserEntity.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch user: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.message}");
    } catch (e) {
      throw Exception("Unknown error: ${e.toString()}");
    }
  }

  @override
  Future<void> updateRegularUser(RegularUserEntity regularUser) async {
    try {
      final username = await _getUsername();
      print("username in update: $username");
      final token = await _getToken();
      print("Token in update: $token");
      Response response = await _dio.put(
        ApiEndpoints.updateRegularUser,
        data: {
          "username": username,
          "bio": regularUser.bio,
          "profilePicture": regularUser.profilePicture,
          "social_links": regularUser.socialLinks,
        },
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : {},
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception("Failed to update user: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.message}");
    } catch (e) {
      throw Exception("Unknown error: ${e.toString()}");
    }
  }
}
