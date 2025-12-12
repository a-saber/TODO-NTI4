import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_nti4/core/helper/app_navigator.dart';
import 'package:todo_nti4/core/helper/app_popup.dart';
import 'package:todo_nti4/core/helper/app_validator.dart';
import 'package:todo_nti4/core/widgets/custom_filled_btn.dart';
import 'package:todo_nti4/core/widgets/custom_form_field.dart';
import 'package:todo_nti4/features/home/views/home_view.dart';
import 'package:todo_nti4/features/task/cubit/add_task_cubit/add_task_cubit.dart';
import 'package:todo_nti4/features/task/cubit/add_task_cubit/add_task_state.dart';



class AddTaskView extends StatelessWidget {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AddTask'),
        ),
        body: BlocConsumer<AddTaskCubit, AddTaskState>(
          listener: (context, state) {
            if(state is AddTaskErrorState){
             SnackBarPopUp().show(
               context: context,
               message: state.error,
               state: PopUpState.error
             );
            }
            else if(state is AddTaskSuccessState){
             SnackBarPopUp().show(
               context: context,
               message: 'Taske added successfully',
               state: PopUpState.success
             );

             Navigator.pop(context, true);
            }
          },
          builder: (context, state) {
            return Form(
              key: AddTaskCubit.get(context).formKey,
              child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CustomFormField(
                    controller: AddTaskCubit.get(context).title,
                    prefix: Icon(Icons.title), 
                    hintText: 'Title',
                    validator: AppValidator.validateRequired,
                  ),
                  SizedBox(height: 20,),
                  CustomFormField(
                    controller: AddTaskCubit.get(context).description,
                    prefix: Icon(Icons.description), 
                    hintText: 'Description',
                    validator: AppValidator.validateRequired, 
                  ),
                  SizedBox(height: 20,),
                 
                  state is AddTaskLoadingState?
                  CircularProgressIndicator():
                  CustomFilledBtn(
                    onPressed: AddTaskCubit.get(context).onAddTaskPressed, 
                    text: 'Add Task'
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