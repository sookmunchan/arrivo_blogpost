// lib/bloc/user_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:blog_post/bloc/user/user_event.dart';
import 'package:blog_post/bloc/user/user_state.dart';
import 'package:blog_post/repository/api_repository.dart';

// Define User BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiRepository apiRepository;

  UserBloc(this.apiRepository) : super(UserInitial()) {
    on<FetchUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await apiRepository.fetchUsers();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError('Failed to load users'));
      }
    });
  }
}
