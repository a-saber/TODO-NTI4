import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_nti4/core/helper/app_popup.dart';
import 'package:todo_nti4/core/helper/app_validator.dart';
import 'package:todo_nti4/core/widgets/custom_filled_btn.dart';
import 'package:todo_nti4/core/widgets/custom_form_field.dart';
import 'package:todo_nti4/features/home/cubit/get_tasks_cubit/get_tasks_cubit.dart';
import 'package:todo_nti4/features/home/data/models/tassk_model.dart';
import 'package:todo_nti4/features/task/cubit/delete_task_cubit/delete_task_cubit.dart';
import 'package:todo_nti4/features/task/cubit/delete_task_cubit/delete_task_state.dart';
import 'package:todo_nti4/features/task/cubit/update_task_cubit/update_task_cubit.dart';
import 'package:todo_nti4/features/task/cubit/update_task_cubit/update_task_state.dart';



class UpdateTaskView extends StatelessWidget {
  const UpdateTaskView({super.key, required this.taskModel});
final TaskModel taskModel;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateTaskCubit(taskModel),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('UpdateTask'),
          actions: [
            BlocProvider(
              create: (context) => DeleteTaskCubit(),
              child: BlocConsumer<DeleteTaskCubit, DeleteTaskState>(
                listener: (context, state) {
            if(state is DeleteTaskErrorState){
             SnackBarPopUp().show(
               context: context,
               message: state.error,
               state: PopUpState.error
             );
            }
            else if(state is DeleteTaskSuccessState){
             SnackBarPopUp().show(
               context: context,
               message: 'Taske Deleted successfully',
               state: PopUpState.success
             );

             GetTasksCubit.get(context).getTasks();
             Navigator.pop(context,);
            //  Navigator.pop(context, true);

            }
          },
          
                builder: (context, state) {
                  
                  return Column(
                    children: [
                      TextButton(
                        onPressed: state is! DeleteTaskLoadingState? 
                        ()=> DeleteTaskCubit.get(context).onDeleteTaskPressed(taskModel.id!)
                        : null,
                         child: Text('Delete', style: TextStyle(color: Colors.red)
                      ,)),
                      if(state is DeleteTaskLoadingState)
                    SizedBox(
                      width: 50,
                      child: LinearProgressIndicator())
                  
                    ],
                  );
                }
              ),
            )
          ],
        ),
        body: BlocConsumer<UpdateTaskCubit, UpdateTaskState>(
          listener: (context, state) {
            if(state is UpdateTaskErrorState){
             SnackBarPopUp().show(
               context: context,
               message: state.error,
               state: PopUpState.error
             );
            }
            else if(state is UpdateTaskSuccessState){
             SnackBarPopUp().show(
               context: context,
               message: 'Taske Updateed successfully',
               state: PopUpState.success
             );

             GetTasksCubit.get(context).getTasks();
             Navigator.pop(context,);
            //  Navigator.pop(context, true);

            }
          },
          builder: (context, state) {
            return Form(
              key: UpdateTaskCubit.get(context).formKey,
              child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if(taskModel.imagePath != null && UpdateTaskCubit.get(context).image == null)
                   Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(taskModel.imagePath!)))
                    ),
                  

                    if(UpdateTaskCubit.get(context).image != null)
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: FileImage(File(UpdateTaskCubit.get(context).image!.path)))
                    ),
                  ),
                  CustomFilledBtn(onPressed: UpdateTaskCubit.get(context).pickImage, text: 'Pick Image'),
                  CustomFormField(
                    controller: UpdateTaskCubit.get(context).title,
                    prefix: Icon(Icons.title), 
                    hintText: 'Title',
                    validator: AppValidator.validateRequired,
                  ),
                  SizedBox(height: 20,),
                  CustomFormField(
                    controller: UpdateTaskCubit.get(context).description,
                    prefix: Icon(Icons.description), 
                    hintText: 'Description',
                    validator: AppValidator.validateRequired, 
                  ),
                  SizedBox(height: 20,),
                 
                  state is UpdateTaskLoadingState?
                  CircularProgressIndicator():
                  CustomFilledBtn(
                    onPressed: UpdateTaskCubit.get(context).onUpdateTaskPressed, 
                    text: 'Update Task'
                  ),
                  SizedBox(height: 40,),
                  
                  
                ],
              ),
            ));
          }
        ),
      ),
    );
  }
}