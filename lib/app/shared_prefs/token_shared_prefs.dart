import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenSharedPrefs {
  final SharedPreferences _sharedPreferences;

  TokenSharedPrefs(this._sharedPreferences);

  SharedPreferences get sharedPreferences => _sharedPreferences;

  Future<Either<Failure, void>> saveToken(String token) async {
    try {
      await _sharedPreferences.setString('token', token);
      return const Right(null);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> getToken() async {
    try {
      final token = _sharedPreferences.getString('token');
      return Right(token ?? '');
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> getUserId() async {
    try {
      final userId = _sharedPreferences.getString('id');
      debugPrint("User ID saved: $userId");
      return Right(userId ?? '');
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> saveUserId(String userId) async {
    try {
      await _sharedPreferences.setString('userId', userId);
      return const Right(null);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> getUsername() async {
    try {
      final username = _sharedPreferences.getString('username');
      debugPrint("Username saved: $username");
      return Right(username ?? '');
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> saveUsername(String username) async {
    try {
      await _sharedPreferences.setString('username', username);
      return const Right(null);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }
}
