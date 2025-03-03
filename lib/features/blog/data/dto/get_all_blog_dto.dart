import 'package:json_annotation/json_annotation.dart';
import 'package:linkora_app/features/blog/data/model/blog_api_model.dart';

part 'get_all_blog_dto.g.dart';

@JsonSerializable()
class GetAllBlogDTO {
  final bool success;
  final int count;
  final List<BlogApiModel> data;

  GetAllBlogDTO({
    required this.success,
    required this.count,
    required this.data,
  });

  Map<String, dynamic> toJson() => _$GetAllBlogDTOToJson(this);

  factory GetAllBlogDTO.fromJson(Map<String, dynamic> json) =>
      _$GetAllBlogDTOFromJson(json);
}
