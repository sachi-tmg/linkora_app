import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:linkora_app/features/regular_user/domain/entity/regular_user_entity.dart';

@JsonSerializable()
class RegularUserApiModel extends Equatable {
  final String userId;
  final String? imageName;

  const RegularUserApiModel({
    required this.userId,
    this.imageName,
  });

  const RegularUserApiModel.empty()
      : userId = '',
        imageName = '';

  factory RegularUserApiModel.fromJson(Map<String, dynamic> json) {
    return RegularUserApiModel(
      userId: json['_id'],
      imageName: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageName': imageName,
    };
  }

  factory RegularUserApiModel.fromEntity(RegularUserEntity entity) =>
      RegularUserApiModel(
        userId: entity.userId,
        imageName: entity.profilePicture,
      );

  // To Entity
  RegularUserEntity toEntity() => RegularUserEntity(
        userId: userId,
        profilePicture: imageName,
      );

  static List<RegularUserEntity> toEntityList(
          List<RegularUserApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  // TODO: implement props
  List<Object?> get props => [userId, imageName];
}
