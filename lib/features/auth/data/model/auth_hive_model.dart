import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:linkora_app/app/constants/hive_table_constant.dart';
import 'package:linkora_app/features/auth/domain/entity/auth_entity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class AuthHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String fullName;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String password;

  AuthHiveModel({
    String? userId,
    required this.fullName,
    required this.email,
    required this.password,
  }) : userId = userId ?? const Uuid().v4();

  // Initial Constructor
  const AuthHiveModel.initial()
      : userId = '',
        fullName = '',
        email = '',
        password = '';

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
    );
  }

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      password: password,
    );
  }

  @override
  List<Object?> get props => [userId, fullName, email, password];
}
