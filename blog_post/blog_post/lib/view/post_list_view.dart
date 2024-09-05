import 'package:blog_post/model/post_model.dart';
import 'package:blog_post/view/post_detail_view.dart';
import 'package:blog_post/view/add_edit_post_view.dart';
import 'package:flutter/material.dart';
import 'package:blog_post/controller/post_list_controller.dart';

class PostListPage extends StatefulWidget {
  final int userId;
  final String name;

  PostListPage({required this.userId, required this.name});

  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  late PostListController _controller;
  late Future<List<PostModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _controller = PostListController(widget.userId);
    _postsFuture = _controller.fetchPosts();
  }

  void _navigateToEditPage(int postId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditPostPage(postId: postId),
      ),
    ).then((_) {
      // Refresh the list when returning from the edit page
      setState(() {
        _postsFuture = _controller.fetchPosts();
      });
    });
  }

  void _navigateToAddEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddEditPostPage(), // Navigate to the AddEditPostPage for new posts
      ),
    ).then((_) {
      // Refresh the list when returning from the add page
      setState(() {
        _postsFuture = _controller.fetchPosts();
      });
    });
  }

  void _navigateToPostDetailPage(PostModel post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(post: post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.purpleAccent,
            ),
            onPressed: () => _navigateToAddEditPage(),
          ),
        ],
      ),
      body: FutureBuilder<List<PostModel>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts found'));
          } else {
            final posts = snapshot.data!;

            return ListView.separated(
              itemCount: posts.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final post = posts[index];
                return GestureDetector(
                  onTap: () => _navigateToPostDetailPage(post),
                  child: ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.body),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _navigateToEditPage(post.id),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
