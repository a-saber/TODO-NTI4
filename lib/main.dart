import 'package:flutter/material.dart';
import 'package:todo_nti4/core/utils/app_colors.dart';

import 'features/auth/views/register_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary)
      ),
      // TODO: check if user is logged in
      home: RegisterView(),
    );
  }
}
