
abstract class AddTaskState {}

class AddTaskInitialState extends AddTaskState {}

class AddTaskLoadingState extends AddTaskState {}

class AddTaskSuccessState extends AddTaskState {}
class AddTaskImageChangedState extends AddTaskState {}

class AddTaskErrorState extends AddTaskState {
  final String error;
  AddTaskErrorState(this.error);
}