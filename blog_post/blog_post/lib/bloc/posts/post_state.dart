// lib/bloc/post_state.dart

import 'package:blog_post/model/post_model.dart';
import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {
  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoadedForUser extends PostState {
  final List<PostModel> posts;

  PostLoadedForUser(this.posts);

  @override
  List<Object> get props => [posts];
}

class PostError extends PostState {
  final String message;

  PostError(this.message);

  @override
  List<Object> get props => [message];
}
