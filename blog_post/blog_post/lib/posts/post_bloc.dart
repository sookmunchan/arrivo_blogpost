// lib/bloc/post_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:blog_post/repository/api_repository.dart';
import 'package:blog_post/model/post_model.dart';
import 'package:equatable/equatable.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final ApiRepository apiRepository;

  PostBloc(this.apiRepository) : super(PostInitial()) {
    on<FetchPostsForUser>((event, emit) async {
      emit(PostLoading());
      try {
        final posts = await apiRepository.fetchPosts(event.userId);
        emit(PostLoadedForUser(posts));
      } catch (e) {
        emit(PostError('Failed to load posts'));
      }
    });

    on<DeletePost>((event, emit) async {
      try {
        await apiRepository.deletePost(event.postId);
      } catch (e) {
        emit(PostError('Failed to load posts'));
      }
    });
  }
}
