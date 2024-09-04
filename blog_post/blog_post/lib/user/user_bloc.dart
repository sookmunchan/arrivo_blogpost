// lib/bloc/user_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:blog_post/api_repository.dart';
import 'package:blog_post/model/user_model.dart';
import 'package:equatable/equatable.dart';

// Define User Events
abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUsers extends UserEvent {}

// Define User States
abstract class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users;

  UserLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UserError extends UserState {
  final String message;

  UserError(this.message);

  @override
  List<Object> get props => [message];
}

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
