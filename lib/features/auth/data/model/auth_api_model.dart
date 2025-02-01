import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:linkora_app/features/auth/domain/entity/auth_entity.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String fullName;
  final String email;
  final String password;

  const AuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  AuthEntity toEntity() {
    return AuthEntity(
      userId: id,
      fullName: fullName,
      email: email,
      password: password,
    );
  }

  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
