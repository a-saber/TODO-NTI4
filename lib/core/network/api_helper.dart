import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_response.dart';
import 'end_points.dart';

class ApiHelper
{
  // singleton
  static final ApiHelper _instance = ApiHelper._init();
  factory ApiHelper() {
    _instance.initDio();
    return _instance;
  }
  ApiHelper._init();

  Dio dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseURL,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
      )
  );

  void initDio() {
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          print("--- Headers : ${options.headers.toString()}");
          print("--- endpoint : ${options.path.toString()}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("--- Response : ${response.data.toString()}");
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          print("--- Error : ${error.response?.data.toString()}");
          //ApiResponse apiResponse = ApiResponse.fromError(error);
          if(error.response?.data['message'].contains('expired'))
          {
            // refresh token
            try {
              ApiResponse apiResponse = await _instance.postRequest(
                  endPoint:  EndPoints.refreshToken,
                  sendRefreshToken: true,
                  isProtected: true
              );
              if (apiResponse.status) {
                var sharedPref = await SharedPreferences.getInstance();
                // must update token
                await sharedPref.setString( 'access_token', apiResponse.data['access_token']);

                // Retry original request
                final options = error.requestOptions;
                if (options.data is FormData) {
                  final oldFormData = options.data as FormData;

                  // Convert FormData to map so it can be rebuilt
                  final Map<String, dynamic> formMap = {};
                  for (var entry in oldFormData.fields) {
                    formMap[entry.key] = entry.value;
                  }

                  // Add files if any
                  for (var file in oldFormData.files) {
                    formMap[file.key] = file.value;
                  }

                  // Rebuild new FormData
                  options.data = FormData.fromMap(formMap);
                }
                options.headers['Authorization'] = 'Bearer ${sharedPref.getString('access_token') ?? ''}';
                final response = await dio.fetch(options);
                return handler.resolve(response);
              }
              else
              {
                // must logout
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.remove('access_token');
                sharedPreferences.remove('refresh_token');
                return handler.next(error);
              }

            } catch (e) {
              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.remove('access_token');
              sharedPreferences.remove('refresh_token');
              return handler.next(error);
            }

          }

          return handler.next(error);
        }
    ));

  }
  Future<ApiResponse> postRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isProtected = false,
    bool sendRefreshToken = false
  }) async
  {
    var token;
    if(isProtected){
      var sharedPref = await SharedPreferences.getInstance();
      token = sharedPref.getString(sendRefreshToken? 'refresh_token' :'access_token');
    }
    return ApiResponse.fromResponse(await dio.post(
        endPoint,
        data: isFormData? FormData.fromMap(data??{}): data,
        options: Options(
            headers: {
              if(isProtected)'Authorization': 'Bearer $token'
            }
        )
    ));
  }
  Future<ApiResponse> getRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = true,
    bool isProtected = false,
    bool sendRefreshToken = false

  }) async
  {
    var token;
    if(isProtected){
      var sharedPref = await SharedPreferences.getInstance();
      token = sharedPref.getString(sendRefreshToken? 'refresh_token' :'access_token');
    }
    return ApiResponse.fromResponse(await dio.get(
      endPoint,
      queryParameters: queryParameters,
      data: isFormData? FormData.fromMap(data??{}): data,
      options: Options(
        headers: {
          if(isProtected)'Authorization': 'Bearer $token'
        }
      )
    ));
  }

  Future<ApiResponse> putRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = true,
    bool isProtected = false,
    bool sendRefreshToken = false

  }) async
  {
    var token;
    if(isProtected){
      var sharedPref = await SharedPreferences.getInstance();
      token = sharedPref.getString(sendRefreshToken? 'refresh_token' :'access_token');
    }
    return ApiResponse.fromResponse(await dio.put(
      endPoint,
      queryParameters: queryParameters,
      data: isFormData? FormData.fromMap(data??{}): data,
      options: Options(
        headers: {
          if(isProtected)'Authorization': 'Bearer $token'
        }
      )
    ));
  }
  Future<ApiResponse> deleteRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = true,
    bool isProtected = false,
    bool sendRefreshToken = false

  }) async
  {
    var token;
    if(isProtected){
      var sharedPref = await SharedPreferences.getInstance();
      token = sharedPref.getString(sendRefreshToken? 'refresh_token' :'access_token');
    }
    return ApiResponse.fromResponse(await dio.delete(
      endPoint,
      queryParameters: queryParameters,
      data: isFormData? FormData.fromMap(data??{}): data,
      options: Options(
        headers: {
          if(isProtected)'Authorization': 'Bearer $token'
        }
      )
    ));
  }

}


