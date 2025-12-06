import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_nti4/features/auth/data/model/user_model.dart';

import '../../data/repo/home_repo.dart';
import 'get_user_data_state.dart';

class GetUserDataCubit extends Cubit<GetUserDataState>{
  GetUserDataCubit() : super(GetUserDataInitialState());
  static GetUserDataCubit get(context) => BlocProvider.of(context);


  void getUserDataPressed()async
  {
      emit(GetUserDataLoadingState());
      HomeRepo repo = HomeRepo();
      var result= await repo.getUserData();
      result.fold((String error)=> emit(GetUserDataErrorState(error)),
       (UserModel user)=> emit(GetUserDataSuccessState(user))
        );


  }

}