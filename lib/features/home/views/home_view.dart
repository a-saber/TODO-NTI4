import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_nti4/core/helper/app_navigator.dart';
import 'package:todo_nti4/core/utils/app_colors.dart';
import 'package:todo_nti4/features/auth/views/login_view.dart';
import 'package:todo_nti4/features/home/cubit/get_tasks_cubit/get_tasks_cubit.dart';
import 'package:todo_nti4/features/home/cubit/get_tasks_cubit/get_tasks_state.dart';
import 'package:todo_nti4/features/home/cubit/get_user_data_cubit/get_user_data_cubit.dart';
import 'package:todo_nti4/features/home/cubit/get_user_data_cubit/get_user_data_state.dart';
import 'package:todo_nti4/features/task/views/add_task_view.dart';
import 'package:todo_nti4/features/task/views/update_task_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            shape: CircleBorder(),
            onPressed: ()async{
              bool added = await AppNavigator.goTo(context, AddTaskView())??false;
              if(added){
                GetTasksCubit.get(context).getTasks();
              }
            }, child: Icon(Icons.add),);
        }
      ),
      appBar: AppBar(
        title: BlocProvider(
          create: (context) => GetUserDataCubit()..getUserDataPressed(),
          child: BlocBuilder<GetUserDataCubit, GetUserDataState>(
            builder: (context, state) {
              if(state is GetUserDataSuccessState){
                 return Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: CachedNetworkImage(
                      imageUrl: state.user.imagePath??'', 
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome'),
                      Text(state.user.username??''),
                    ],
                  )
                ],
              );
              }
              else if (state is GetUserDataLoadingState){
                return Center(child: CircularProgressIndicator(),);
              }
              else if (state is GetUserDataErrorState){
                return Center(child: Row(
                  children: [
                    TextButton(onPressed: ()async{
                      var pref = await SharedPreferences.getInstance();
                      pref.remove('access_token');
                      AppNavigator.goTo(context, LoginView(), replaceAll: true);
                    }, child: Text('Logout')),
                    Text(state.error),
                  ],
                ),);
              }
              return Container();
             }
          ),
        ),
        actions: [
          IconButton(onPressed: ()async{
            var pref = await SharedPreferences.getInstance();
            pref.remove('access_token');
            pref.remove('refresh_token');
            AppNavigator.goTo(context, LoginView(), replaceAll: true);
          }, 
          icon: Icon(Icons.logout))
        ],
      ),
      body: Builder(
        builder: (context) {
          return RefreshIndicator(
            onRefresh: () async{
              GetTasksCubit.get(context).getTasks();
            },
            child: BlocBuilder<GetTasksCubit, GetTasksState>(
              builder: (context, state) {
                if(state is GetTasksSuccessState){
                  
                  return ListView.separated(
                  padding: EdgeInsets.all(20),
                  itemBuilder: (context, index)=> InkWell(
                    onTap: (){
                      AppNavigator.goTo(context, 
                      UpdateTaskView(taskModel: state.tasks[index]));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(155),
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: Offset.zero,
                          )
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: 
                        [
                          Container(
                            height: 50,
                            width: 50,
                            child: CachedNetworkImage(
                              imageUrl: state.tasks[index].imagePath??'',
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.tasks[index].title??''),
                                Text(state.tasks[index].description??''),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ), separatorBuilder: (context, index)=> SizedBox(height: 20,),
                   itemCount: state.tasks.length);
                }
                else if(state is GetTasksLoadingState){
                  return Center(child: CircularProgressIndicator(),);
                }
                else if(state is GetTasksErrorState){
                  return Center(child: Text(state.error),);
                }
                return Container();
            
                
              }
            ),
          );
        }
      ),
    
    );
  }
}