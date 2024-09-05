// lib/main.dart

import 'package:blog_post/bloc/user/user_event.dart';
import 'package:blog_post/repository/api_repository.dart';
import 'package:blog_post/bloc/user/user_bloc.dart';
import 'package:blog_post/view/user_lists_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => UserBloc(ApiRepository())..add(FetchUsers()),
        child: UserListPage(), // Use the UserListPage
      ),
    );
  }
}
