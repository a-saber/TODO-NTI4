import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_nti4/core/network/api_helper.dart';
import 'package:todo_nti4/core/network/api_response.dart';
import 'package:todo_nti4/core/network/end_points.dart';

class TaskRepo {

  ApiHelper apiHelper = ApiHelper();
  Future<Either<String, Unit>> addTask({
    required String title,
    required String description,
    XFile? image
  }) async 
  {
    try{
      var response = await apiHelper.postRequest(
        endPoint: EndPoints.newTask,
        isProtected: true,
        data: {
          'title': title,
          'description': description,
          if(image != null) 'image': await MultipartFile.fromFile(image.path)
        }
      );
      if(response.status){
        return right(unit);
      }
      else{
        return left(response.message);
      }
    }
    catch(e){
      return left(ApiResponse.fromError(e).message);
    }
  }


  Future<Either<String, String>> updateTask({
    required String title,
    required String description,
    required int taskId,
    XFile? image

  }) async 
  {
    try{
      var response = await apiHelper.putRequest(
        endPoint: '${EndPoints.updateOrDeleteTask}/$taskId',
        isProtected: true,
        data: {
          'title': title,
          'description': description,
          if(image != null) 'image': await MultipartFile.fromFile(image.path)

        }
      );
      if(response.status){
        return right(response.message);
      }
      else{
        return left(response.message);
      }
    }
    catch(e){
      return left(ApiResponse.fromError(e).message);
    }
  }

  Future<Either<String, String>> deleteTask({
    required int taskId
  }) async 
  {
    try{
      var response = await apiHelper.deleteRequest(
        endPoint: '${EndPoints.updateOrDeleteTask}/$taskId',
        isProtected: true,
      );
      if(response.status){
        return right(response.message);
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