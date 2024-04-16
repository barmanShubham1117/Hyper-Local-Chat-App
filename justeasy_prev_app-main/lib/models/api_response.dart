import 'package:justeasy/controllers/auth_controller.dart';
import 'package:justeasy/helpers/console.dart';

class ApiResponse{
  final Map<String,dynamic>data;
  final bool success; 
  final int code;
  final Map<String,dynamic> message;
  ApiResponse({
    required this.data,
    required this.success,
    required this.code,
    required this.message,
  });
  static ApiResponse fromJson(final jsonData){
    Console.log(jsonData,r: true);
    var response = ApiResponse(
      data: jsonData["data"]??{},
      message: jsonData["message"]??{},
      code: jsonData["response_code"]??400,
      success: jsonData["success"]??false,
    );
    return response;
  }
}