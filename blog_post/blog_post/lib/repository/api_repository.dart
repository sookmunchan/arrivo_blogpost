// lib/repositories/user_repository.dart

import 'dart:convert';
import 'package:blog_post/model/comments_model.dart';
import 'package:blog_post/model/post_model.dart';
import 'package:blog_post/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiRepository {
  final String baseUrl;

  ApiRepository({this.baseUrl = 'https://jsonplaceholder.typicode.com'});

  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }
  }

  Future<List<Comment>> fetchComments(int postId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/posts/$postId/comments'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<PostModel> fetchPostByPostId(int postId) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/$postId'));

    if (response.statusCode == 200) {
      return PostModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<List<PostModel>> fetchPostByUserId(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/posts?userId=$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> savePost(PostModel post) async {
    final url = post.id == 0 ? '$baseUrl/posts' : '$baseUrl/posts/${post.id}';
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final body = post.id == 0
        ? jsonEncode({
            'title': post.title,
            'body': post.body,
            'userId': post.userId,
          })
        : jsonEncode({
            'title': post.title,
            'body': post.body,
            'userId': post.userId,
            'id': 0,
          });

    try {
      final response = post.id == 0
          ? await http.post(
              Uri.parse(url),
              headers: headers,
              body: body,
            )
          : await http.put(
              Uri.parse(url),
              headers: headers,
              body: body,
            );

      print('addeditpost::${response.body},,${post.id},,$url');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Handle success if needed
      } else {
        throw Exception('Failed to save post');
      }
    } catch (e) {
      // Handle network error
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<bool> updatePostTitle(int postId, String newTitle) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/posts/$postId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'title': newTitle,
      }),
    );
    return response.statusCode ==
        200; // Return true if the update is successful
  }
}
