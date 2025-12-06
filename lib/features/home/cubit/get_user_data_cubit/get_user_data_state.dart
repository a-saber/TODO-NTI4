import 'package:todo_nti4/features/auth/data/model/user_model.dart';

abstract class GetUserDataState {}

class GetUserDataInitialState extends GetUserDataState {}

class GetUserDataLoadingState extends GetUserDataState {}

class GetUserDataSuccessState extends GetUserDataState {
  final UserModel user;
  GetUserDataSuccessState(this.user);
}

class GetUserDataErrorState extends GetUserDataState {
  final String error;
  GetUserDataErrorState(this.error);
}