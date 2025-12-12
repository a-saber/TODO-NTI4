import 'package:todo_nti4/features/auth/data/model/user_model.dart';

abstract class AddTaskState {}

class AddTaskInitialState extends AddTaskState {}

class AddTaskLoadingState extends AddTaskState {}

class AddTaskSuccessState extends AddTaskState {}

class AddTaskErrorState extends AddTaskState {
  final String error;
  AddTaskErrorState(this.error);
}