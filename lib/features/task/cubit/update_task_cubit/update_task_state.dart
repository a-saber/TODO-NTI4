
abstract class UpdateTaskState {}

class UpdateTaskInitialState extends UpdateTaskState {}

class UpdateTaskLoadingState extends UpdateTaskState {}
class UpdateTaskImageChangedState extends UpdateTaskState {}

class UpdateTaskSuccessState extends UpdateTaskState {}

class UpdateTaskErrorState extends UpdateTaskState {
  final String error;
  UpdateTaskErrorState(this.error);
}