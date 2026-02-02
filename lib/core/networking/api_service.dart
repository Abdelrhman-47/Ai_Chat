import 'package:ai_chat/core/networking/dio_clint.dart';

class ApiServices {
    final DioClient _dioClient;

  ApiServices({required DioClient dioClient}) : _dioClient = dioClient;
    

    Future <dynamic> post(String endPoint,Map<String, dynamic> body)async{
      final response =await _dioClient.dio.post(endPoint,data: body);
      return response.data;
    }

    
    
    }