// lib/pages/post_details_page.dart
import 'package:blog_post/model/comments_model.dart';
import 'package:blog_post/model/post_model.dart';
import 'package:blog_post/repository/api_repository.dart';
import 'package:flutter/material.dart';

class PostDetailPage extends StatefulWidget {
  final PostModel post;

  PostDetailPage({required this.post});
  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late Future<List<Comment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = ApiRepository().fetchComments(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  widget.post.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 20.0),
                Text(
                  widget.post.body,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Container(
            height: 50.0,
            width: double.infinity,
            color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Comments',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load comments'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No comments available'));
                }

                final comments = snapshot.data!;

                return ListView.separated(
                  physics: ClampingScrollPhysics(),
                  itemCount: comments.length,
                  separatorBuilder: (context, index) =>
                      Divider(height: 1.0, color: Colors.grey),
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                        title: Text(
                          comment.name,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          comment.body,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        ));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
