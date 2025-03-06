// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BlogHiveModelAdapter extends TypeAdapter<BlogHiveModel> {
  @override
  final int typeId = 1;

  @override
  BlogHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlogHiveModel(
      id: fields[0] as String?,
      blogId: fields[1] as String?,
      title: fields[2] as String,
      description: fields[3] as String,
      blogPicture: fields[4] as String,
      content: (fields[5] as List?)?.cast<String>(),
      draft: fields[6] as bool?,
      activity: (fields[7] as Map).cast<String, dynamic>(),
      tags: (fields[8] as List?)?.cast<String>(),
      dateCreated: fields[9] as DateTime?,
      user: (fields[10] as Map).cast<String, dynamic>(),
      profilePicture: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BlogHiveModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.blogId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.blogPicture)
      ..writeByte(5)
      ..write(obj.content)
      ..writeByte(6)
      ..write(obj.draft)
      ..writeByte(7)
      ..write(obj.activity)
      ..writeByte(8)
      ..write(obj.tags)
      ..writeByte(9)
      ..write(obj.dateCreated)
      ..writeByte(10)
      ..write(obj.user)
      ..writeByte(11)
      ..write(obj.profilePicture);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlogHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
