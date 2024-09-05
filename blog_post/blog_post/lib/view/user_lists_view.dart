import 'package:blog_post/controller/user_lists_controller.dart';
import 'package:blog_post/model/user_model.dart';
import 'package:blog_post/view/post_list_view.dart';
import 'package:flutter/material.dart';

class UserListPage extends StatelessWidget {
  void _navigateToPostListPage(BuildContext context, int userId, String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostListPage(
          userId: userId,
          name: name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserListsController controller = UserListsController();

    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: FutureBuilder<List<UserModel>>(
        future: controller.usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while the data is being fetched
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show an error message if data fetching fails
            return Center(child: Text('Failed to load users'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users available'));
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(user.id.toString()), // Display user ID in avatar
                ),
                title: Text(user.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(user.username), Text(user.email)],
                ),
                onTap: () =>
                    _navigateToPostListPage(context, user.id, user.name),
              );
            },
          );
        },
      ),
    );
  }
}
