import 'package:blog_post/controller/post_detail_controller.dart';
import 'package:blog_post/model/comments_model.dart';
import 'package:blog_post/model/post_model.dart';
import 'package:blog_post/widget/textfield_widget.dart';
import 'package:flutter/material.dart';

class PostDetailPage extends StatefulWidget {
  final PostModel post;

  PostDetailPage({required this.post});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late PostDetailController _controller;
  late TextEditingController _titleController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = PostDetailController(widget.post.id);
    _titleController = TextEditingController(text: widget.post.title);
    _controller.fetchComments();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _updateTitle() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final success = await _controller.updatePostTitle(_titleController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Title updated successfully'
              : 'Failed to update title'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Content'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _updateTitle(),
                        child: Text('Save'),
                      ),
                    ),
                    TextfieldWidget(
                      textController: _titleController,
                      labelTxt: 'Title',
                      formValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      widget.post.body,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Expanded(child: _commentsListView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _commentsListView() {
    return Column(
      children: [
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
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Comment>>(
            future: _controller.commentsFuture,
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
                itemCount: comments.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1.0, color: Colors.grey),
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return ListTile(
                    title: Text(
                      comment.name,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      comment.body,
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
