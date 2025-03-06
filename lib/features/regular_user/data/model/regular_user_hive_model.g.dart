// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regular_user_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RegularUserHiveModelAdapter extends TypeAdapter<RegularUserHiveModel> {
  @override
  final int typeId = 2;

  @override
  RegularUserHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RegularUserHiveModel(
      userId: fields[0] as String?,
      username: fields[1] as String?,
      fullName: fields[2] as String?,
      profilePicture: fields[3] as String,
      bio: fields[4] as String?,
      socialLinks: fields[5] as String,
      totalPosts: fields[6] as int,
      totalReads: fields[7] as int,
      blogs: (fields[8] as List).cast<String>(),
      dateCreated: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RegularUserHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.profilePicture)
      ..writeByte(4)
      ..write(obj.bio)
      ..writeByte(5)
      ..write(obj.socialLinks)
      ..writeByte(6)
      ..write(obj.totalPosts)
      ..writeByte(7)
      ..write(obj.totalReads)
      ..writeByte(8)
      ..write(obj.blogs)
      ..writeByte(9)
      ..write(obj.dateCreated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegularUserHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
