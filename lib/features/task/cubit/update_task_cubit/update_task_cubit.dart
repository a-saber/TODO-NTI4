import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_nti4/features/home/data/models/tassk_model.dart';
import 'package:todo_nti4/features/task/data/repo/task_repo.dart';

import 'update_task_state.dart';

class UpdateTaskCubit extends Cubit<UpdateTaskState>{
  UpdateTaskCubit(this.taskModel) : super(UpdateTaskInitialState()){
    title.text = taskModel.title??'';
    description.text = taskModel.description??'';
  }
  static UpdateTaskCubit get(context) => BlocProvider.of(context);
  final TaskModel taskModel;
  
  XFile? image;
  void pickImage()async{
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    emit(UpdateTaskImageChangedState());
  }

  var title = TextEditingController();
  var description = TextEditingController();
  var formKey = GlobalKey<FormState>();

  void onUpdateTaskPressed()async
  {
    if(formKey.currentState?.validate() == true){
      emit(UpdateTaskLoadingState());
      TaskRepo repo = TaskRepo();
      var result= await repo.updateTask(
        taskId: taskModel.id!,
        title: title.text, 
        description: description.text,
        image: image
      );
      result.fold((String error)=> emit(UpdateTaskErrorState(error)),
       (u)=> emit(UpdateTaskSuccessState())
      );

    }

  }

}