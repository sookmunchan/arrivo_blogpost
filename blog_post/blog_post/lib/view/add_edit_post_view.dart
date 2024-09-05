import 'package:blog_post/model/post_model.dart';
import 'package:blog_post/controller/add_edit_post_controller.dart';
import 'package:blog_post/widget/textfield_widget.dart';
import 'package:flutter/material.dart';

class AddEditPostPage extends StatefulWidget {
  final int? userId;
  final int? postId;

  AddEditPostPage({this.userId, this.postId});

  @override
  _AddEditPostPageState createState() => _AddEditPostPageState();
}

class _AddEditPostPageState extends State<AddEditPostPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  late AddEditPostController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AddEditPostController(postId: widget.postId, userId: widget.userId);
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    if (widget.postId != null) {
      _fetchPostData();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _fetchPostData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final post = await _controller.fetchPostData();
      if (post != null) {
        _titleController.text = post.title;
        _bodyController.text = post.body;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load post data'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _savePost() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        await _controller.savePost(_titleController.text, _bodyController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save post: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.postId == null ? 'Add Post' : 'Edit Post'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      TextfieldWidget(
                        textController: _bodyController,
                        labelTxt: 'Content',
                        formValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter content';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => _savePost(),
                          child: Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
