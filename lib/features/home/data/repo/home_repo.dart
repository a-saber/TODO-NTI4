import 'package:dartz/dartz.dart';
import 'package:todo_nti4/core/network/api_helper.dart';
import 'package:todo_nti4/core/network/api_response.dart';
import 'package:todo_nti4/core/network/end_points.dart';
import 'package:todo_nti4/features/auth/data/model/user_model.dart';
import 'package:todo_nti4/features/home/data/models/get_tasks_response_model.dart';
import 'package:todo_nti4/features/home/data/models/tassk_model.dart';

class HomeRepo {
  ApiHelper apiHelper = ApiHelper();
  Future<Either<String, List<TaskModel>>> getTasks()async
  {
    try{
      var response = await apiHelper.getRequest(
        endPoint: EndPoints.getTasks,
        isProtected: true
      );
      var getTasksModel = GetTasksReponseModel.fromJson(response.data as Map<String,dynamic>);
      if(response.status){
        return right(getTasksModel.tasks??[]);
      }
      else{
        return left(response.message);
      }
    }
    catch(e){
      return left(ApiResponse.fromError(e).message);
    }
  }


  Future<Either<String, UserModel>> getUserData() async{
    try{

      var response = await apiHelper.getRequest(
        endPoint: EndPoints.getUserData,
        isProtected: true
      );
      if(response.status){
        UserModel user = UserModel.fromJson((response.data as Map<String,dynamic>)['user'] as Map<String,dynamic>);
        return right(user);
      }
      else{
        return left(response.message);
      }

    }
    catch(e){
      return left(ApiResponse.fromError(e).message);
    }
  }
}