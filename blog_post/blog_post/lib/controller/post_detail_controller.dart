import 'dart:async';
import 'package:blog_post/model/comments_model.dart';
import 'package:blog_post/repository/api_repository.dart';
import 'package:flutter/material.dart';

class PostDetailController {
  final int postId;
  final ApiRepository _apiRepository = ApiRepository();
  late Future<List<Comment>> _commentsFuture;

  PostDetailController(this.postId);

  Future<void> fetchComments() async {
    _commentsFuture = _apiRepository.fetchComments(postId);
  }

  Future<bool> updatePostTitle(String newTitle) async {
    try {
      return await _apiRepository.updatePostTitle(postId, newTitle);
    } catch (e) {
      return false;
    }
  }

  Future<List<Comment>> get commentsFuture => _commentsFuture;

  void dispose() {}
}
