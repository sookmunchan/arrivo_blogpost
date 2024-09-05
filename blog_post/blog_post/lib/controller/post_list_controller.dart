import 'package:blog_post/model/post_model.dart';
import 'package:blog_post/repository/api_repository.dart';

class PostListController {
  final ApiRepository _apiRepository = ApiRepository();
  final int userId;

  PostListController(this.userId);

  Future<List<PostModel>> fetchPosts() async {
    try {
      return await _apiRepository.fetchPostByUserId(userId);
    } catch (e) {
      throw Exception('Failed to fetch posts: ${e.toString()}');
    }
  }
}
