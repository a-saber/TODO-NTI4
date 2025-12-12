import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_nti4/features/task/data/repo/task_repo.dart';

import 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState>{
  AddTaskCubit() : super(AddTaskInitialState());
  static AddTaskCubit get(context) => BlocProvider.of(context);

  var title = TextEditingController();
  var description = TextEditingController();
  var formKey = GlobalKey<FormState>();
  XFile? image;
  void pickImage()async{
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    emit(AddTaskImageChangedState());
  }

  void onAddTaskPressed()async
  {
    if(formKey.currentState?.validate() == true){
      emit(AddTaskLoadingState());
      TaskRepo repo = TaskRepo();
      var result= await repo.addTask(
        title: title.text, 
        description: description.text,
        image: image
      );
      result.fold((String error)=> emit(AddTaskErrorState(error)),
       (u)=> emit(AddTaskSuccessState())
      );

    }

  }

}