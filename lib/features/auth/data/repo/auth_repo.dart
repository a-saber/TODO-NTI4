import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_nti4/core/network/api_helper.dart';
import 'package:todo_nti4/core/network/api_response.dart';
import 'package:todo_nti4/core/network/end_points.dart';
import 'package:todo_nti4/features/auth/data/model/basic_response_model.dart';
import 'package:todo_nti4/features/auth/data/model/login_response_model.dart';
import 'package:todo_nti4/features/auth/data/model/user_model.dart';

class AuthRepo {

  ApiHelper apiHelper = ApiHelper();

  Future<Either<String, String>> register({
    required String username,
    required String password,

  })async{
    try{
      
      var response =  await apiHelper.postRequest(
      endPoint: EndPoints.register,
      data: {
        'username': username,
        'password': password 
      }
    );
    
    var basicResponseModel = BasicResponseModel.fromJson(response.data as Map<String,dynamic>);
    if(basicResponseModel.status == true){
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


  Future<Either<String, UserModel>> login ({
    required String username,
    required String password
  })async
  {
    try{
      var response = await apiHelper.postRequest(
        endPoint: EndPoints.login,
        data: {
          'username': username,
          'password': password
        }
      );
      var loginModel = LoginResponseModel.fromJson(response.data as Map<String,dynamic>);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if(loginModel.accessToken != null){
        await prefs.setString('access_token', loginModel.accessToken!);
      }  
      if(loginModel.refreshToken != null){
        await prefs.setString('refresh_token', loginModel.refreshToken!);
      }  

      if(loginModel.status == true && loginModel.user != null){
        return right(loginModel.user!);
      }
      else
      {
        return left(response.message);
      }

    }
    catch(e){
      return left(ApiResponse.fromError(e).message);
    }

  }

}