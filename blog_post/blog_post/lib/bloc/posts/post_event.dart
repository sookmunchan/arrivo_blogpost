// lib/bloc/post_event.dart

import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPostsForUser extends PostEvent {
  final int userId;

  FetchPostsForUser(this.userId);

  @override
  List<Object> get props => [userId];
}

class DeletePost extends PostEvent {
  final int postId;

  DeletePost(this.postId);

  @override
  List<Object> get props => [postId];
}
