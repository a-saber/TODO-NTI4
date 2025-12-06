import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_nti4/features/home/data/models/tassk_model.dart';
import 'package:todo_nti4/features/home/data/repo/home_repo.dart';

import 'get_tasks_state.dart';

class GetTasksCubit extends Cubit<GetTasksState>{
  GetTasksCubit() : super(GetTasksInitialState());
  static GetTasksCubit get(context) => BlocProvider.of(context);

  void getTasks()async
  {
    emit(GetTasksLoadingState());
    HomeRepo repo = HomeRepo();
    var result = await repo.getTasks();
    result.fold((error)=> emit(GetTasksErrorState(error: error)),
     (List<TaskModel> tasks)=> emit(GetTasksSuccessState(tasks: tasks)));
  }
}