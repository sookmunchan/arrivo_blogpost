import 'dart:async';
import 'package:blog_post/model/user_model.dart';
import 'package:blog_post/repository/api_repository.dart';

class UserListsController {
  final ApiRepository _apiRepository = ApiRepository();
  late Future<List<UserModel>> _usersFuture;

  UserListsController() {
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      _usersFuture = _apiRepository.fetchUsers();
    } catch (e) {
      // Handle the error
    }
  }

  Future<List<UserModel>> get usersFuture => _usersFuture;

  void dispose() {}
}
