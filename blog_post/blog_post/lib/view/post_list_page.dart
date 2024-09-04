// lib/pages/post_list_page.dart

import 'package:blog_post/model/post_model.dart';
import 'package:blog_post/view/add_edit_post_page.dart';
import 'package:blog_post/view/post_detail_page.dart';
import 'package:blog_post/repository/api_repository.dart';
import 'package:blog_post/posts/post_bloc.dart';
import 'package:blog_post/posts/post_event.dart';
import 'package:blog_post/posts/post_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostListPage extends StatelessWidget {
  final int userId;
  final String name;

  PostListPage({required this.userId, required this.name});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostBloc(ApiRepository())..add(FetchPostsForUser(userId)),
      child: Scaffold(
        appBar: AppBar(title: Text(name)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditPostPage(
                  userId: userId,
                ),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PostLoadedForUser) {
              final posts = state.posts;
              return ListView.separated(
                itemCount: posts.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  height: 1.0,
                ),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Dismissible(
                    key: Key(post.id.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deletePost(context, post.id);
                    },
                    background: Container(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        _navigateToPostDetailsPage(context, post);
                      },
                      child: ListTile(
                        title: Text(
                          post.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          post.body,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is PostError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('Something went wrong'));
            }
          },
        ),
      ),
    );
  }

  void _navigateToPostDetailsPage(BuildContext context, PostModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(post: item),
      ),
    );
  }

  void _deletePost(BuildContext context, int postId) {
    final postBloc = BlocProvider.of<PostBloc>(context);
    postBloc.add(DeletePost(postId));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post deleted successfully, but not reflected...'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
