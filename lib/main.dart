import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_nti4/core/utils/app_colors.dart';
import 'package:todo_nti4/features/auth/views/login_view.dart';
import 'package:todo_nti4/features/home/views/home_view.dart';

import 'features/auth/views/register_view.dart';
import 'features/home/cubit/get_tasks_cubit/get_tasks_cubit.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');

  runApp(MyApp(isLoggedIn: token != null,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.isLoggedIn = false});
  final bool isLoggedIn;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => isLoggedIn? (GetTasksCubit()..getTasks()) :GetTasksCubit(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary)
        ),
        home:
         isLoggedIn?
         HomeView()
         :
          LoginView(), // TODO
      ),
    );
  }
}
