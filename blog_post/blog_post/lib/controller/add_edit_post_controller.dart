import 'package:blog_post/model/post_model.dart';
import 'package:blog_post/repository/api_repository.dart';

class AddEditPostController {
  final ApiRepository _apiRepository = ApiRepository();
  final int? postId;
  final int? userId;

  AddEditPostController({this.postId, this.userId});

  Future<PostModel?> fetchPostData() async {
    if (postId == null) return null;

    try {
      return await _apiRepository.fetchPostByPostId(postId!);
    } catch (e) {
      throw Exception('Failed to load post data');
    }
  }

  Future<void> savePost(String title, String body) async {
    PostModel post = (postId != null)
        ? PostModel(
            id: postId!,
            title: title,
            body: body,
            userId: userId ?? 0,
          )
        : PostModel(
            id: 0,
            title: title,
            body: body,
            userId: userId ?? 0,
          );

    try {
      await _apiRepository.savePost(post);
    } catch (e) {
      throw Exception('Failed to save post');
    }
  }
}
