import 'dart:convert';

import 'package:flutter/widgets.dart';
import "package:http/http.dart" as http;
import 'package:http/http.dart';
import 'package:justeasy/config/app_config.dart';
import 'package:justeasy/controllers/auth_controller.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/notify.dart';
import 'package:justeasy/helpers/preference_manager.dart';
import 'package:justeasy/models/api_response.dart';
import 'package:justeasy/models/chat_data.dart';
import 'package:justeasy/models/social.dart';
import 'package:justeasy/models/user.dart';
import 'package:justeasy/routes/route_controller.dart';


class ChatController{
  static createChat(BuildContext context, String match,{Social? social})async{
    const url = "${AppConfig.host}/chat/create";
      final response = await http.post(
        Uri.parse(url),
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
        body: {"match":match}
      );
    //  AppRouteController.showLoadingScreen(context, response, (value)async{
      //  AppRouteController.goBack(context);
       var result = ApiResponse.fromJson(jsonDecode(response.body));
       if(AuthController.checkAuthentication(result, context)){
        if(result.success){
          Console.log(result.data["second"]);
          var second = User.fromJson(result.data["second"]);
          AppRouteController.gotoChatScreen(context,result.data["room"],second,social:social);
        }else{
          Notify(
            context: context,
            type: result.success ? 'success' : 'error',
            message: result.message,
            messageType: Notify.APINOTIFICATION
          );
        }
      }
    //  });
  }
  static Future<ApiResponse> pushMessage(BuildContext context, String room, String data, int type)async{
    const url = "${AppConfig.host}/chat/push";
      final response = await http.post(
        Uri.parse(url),
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
        body: {
          "room":room,
          "data":data,
          "type":"$type",
        }
      );

      Console.log(response.body,r:true);
       var result = ApiResponse.fromJson(jsonDecode(response.body));
       AuthController.checkAuthentication(result, context);
       if(!result.success){
         Notify(
            context: context,
            type:result.success ? 'success' : 'error',
            message: result.message,
            messageType: Notify.APINOTIFICATION
          );
       }
       return result;
  }
  static Future<ApiResponse> endChat(BuildContext context, String room)async{
    const url = "${AppConfig.host}/chat/end";
      final response = await http.post(
        Uri.parse(url),
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
        body: {
          "room":room,
        }
      );

      Console.log(response.body,r:true);
       var result = ApiResponse.fromJson(jsonDecode(response.body));
       AuthController.checkAuthentication(result, context);
       return result;
  }
  static Future<List<ChatData>> pullChat(BuildContext context, String room)async{
    const url = "${AppConfig.host}/chat/pull";
      final response = await http.post(
        Uri.parse(url),
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
        body: {"room":room}
      );
    //  AppRouteController.showLoadingScreen(context, response, (value)async{
      //  AppRouteController.goBack(context);
       var result = ApiResponse.fromJson(jsonDecode(response.body));
       List<ChatData> messages = [];
       if(AuthController.checkAuthentication(result, context)){
        if(result.success){
          messages = (result.data["messages"] as List).map<ChatData>((e) => ChatData.fromJson(e)).toList();
        }
      }
    //  });
    return messages;
  }
  static Future<bool> reportChat(BuildContext context, String second, String message, String room)async{
    const url = "${AppConfig.host}/report";
      final response = await http.post(
        Uri.parse(url),
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
        body: {
          "message":message,
          "user_id":second,
          "extra":"{room:${room}}"
        }
      );
    //  AppRouteController.showLoadingScreen(context, response, (value)async{
      //  AppRouteController.goBack(context);
       var result = ApiResponse.fromJson(jsonDecode(response.body));
       List<ChatData> messages = [];
       if(AuthController.checkAuthentication(result, context)){
         Notify(
            context: context,
            type: result.success ? 'success' : 'error',
            message: result.message,
            messageType: Notify.APINOTIFICATION
          );
        if(result.success){
          return true;
        }
      }
    //  });
    return false;
  }
}