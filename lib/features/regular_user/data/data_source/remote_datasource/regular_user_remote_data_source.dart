import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:linkora_app/app/constants/api_endpoints.dart';
import 'package:linkora_app/features/regular_user/data/data_source/regular_user_data_source.dart';
import 'package:linkora_app/features/regular_user/domain/entity/regular_user_entity.dart';

class RegularUserRemoteDataSource implements IRegularDataSource {
  final Dio _dio;

  RegularUserRemoteDataSource(this._dio);

  @override
  Future<void> regularUser(RegularUserEntity ruser) async {
    debugPrint("User ID in Usecase: ${ruser.userId}");
    try {
      Response response = await _dio.put(
        ApiEndpoints.createRegularUser,
        data: {
          "userId": ruser.userId,
          "profilePicture": ruser.profilePicture,
        },
      );
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap(
        {
          'profilePicture': await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        },
      );

      Response response = await _dio.post(
        ApiEndpoints.uploadImage,
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }
}
