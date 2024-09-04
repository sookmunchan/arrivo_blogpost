// lib/pages/user_list_page.dart

import 'package:blog_post/repository/api_repository.dart';
import 'package:blog_post/view/post_list_page.dart';
import 'package:blog_post/posts/post_bloc.dart';
import 'package:blog_post/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User List')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            // Show a loading spinner while the data is being fetched
            return Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            // Show a ListView when the data is successfully loaded
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  leading: CircleAvatar(
                    child:
                        Text(user.id.toString()), // Display user ID in avatar
                  ),
                  title: Text(user.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(user.username), Text(user.email)],
                  ),
                  onTap: () {
                    // Navigate to PostListPage and pass the userId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => PostBloc(ApiRepository()),
                          child: PostListPage(
                            userId: user.id,
                            name: user.name,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is UserError) {
            // Show an error message if data fetching fails
            return Center(child: Text(state.message));
          } else {
            // Handle any other states, if necessary
            return Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }
}
