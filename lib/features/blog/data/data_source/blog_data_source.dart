import 'package:linkora_app/features/blog/domain/entity/blog_entity.dart';

abstract class IBlogDataSource {
  // Fetches the latest blogs with pagination
  Future<List<BlogEntity>> getLatestBlogs(int page);
}
