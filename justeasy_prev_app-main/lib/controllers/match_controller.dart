import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:justeasy/config/app_config.dart';
import 'package:justeasy/controllers/auth_controller.dart';
import 'package:justeasy/controllers/nearby_controller.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/helpers/notify.dart';
import 'package:justeasy/helpers/preference_manager.dart';
import 'package:justeasy/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:justeasy/models/app_notifications.dart';
import 'package:justeasy/models/notifiable.dart';
import 'package:justeasy/models/user.dart';
import 'package:justeasy/routes/route_controller.dart';

class MatchController{
  static getMatches(BuildContext context)async{
      const url = "${AppConfig.host}/users/get/match";
      final response = await http.get(
        Uri.parse(url),
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
      );
      var result = ApiResponse.fromJson(jsonDecode(response.body));
      var count = 0;
      if(AuthController.checkAuthentication(result, context)){
        count = result.data['count'];
      }
        // DataManager.saveUserData(user);
        DataManager.notificationNotifier.value = count;
        // return user;
  }
  static updateMatch(BuildContext context, String match, String action)async{
      const url = "${AppConfig.host}/users/match";
      final response = await http.post(
        Uri.parse(url),
        body: {"user_id":match, "action":action},
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
      );

      // Console.log(response);
      var result = ApiResponse.fromJson(jsonDecode(response.body));
      if(AuthController.checkAuthentication(result, context)){
        Notify(
          context: context,
          type:result.success ? 'success' : 'error',
          message: result.message,
          messageType: Notify.APINOTIFICATION
        );
        if(result.success) {
          User user = await NearByController.getUserByID(context,match);
          if(result.data["match"] != null)AppRouteController.gotoConnectScreen(context,user,result.data['match'],match);
        }else {
          AppRouteController.goBack(context);
        }
      }
  }
  static creatMatch(BuildContext context, String user_id)async{
      const url = "${AppConfig.host}/users/match";
      final response = await http.post(
        Uri.parse(url),
        body: {"user_id":user_id},
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
      );

      Console.log(response.body);
      var result = ApiResponse.fromJson(jsonDecode(response.body));
      Console.log(result.data);
      if(AuthController.checkAuthentication(result, context)){
        if(result.data["redirect"] == 0){
          AppRouteController.gotoConnectScreen(context, User.fromJson(result.data['second']), result.data["match"], result.data['second']["_id"]);
        }else if(result.data["redirect"] == 1){
          AppRouteController.gotoChatScreen(context, result.data["room"], User.fromJson(result.data['second']));
        }else if(result.data["redirect"] == 2){
          AppRouteController.gotoConnectionRequestScreen(context, User.fromJson(result.data['second']), result.data["match"], result.data["second"]["user_id"]);
          // AppRouteController.gotoConnectionRequestScreen(context, DataManager.user, result.data["match"], result.data["second"]);
          Notify(
            context: context,
            type:result.success ? 'success' : 'error',
            message: result.message,
            messageType: Notify.APINOTIFICATION
          );
        }else{
           Notify(
            context: context,
            type:result.success ? 'success' : 'error',
            message: result.message,
            messageType: Notify.APINOTIFICATION
          );
        }
        // if(result.success) {
        //   if(result.data["match"] != null)AppRouteController.gotoConnectScreen(context,result.data['match']);
        // }else {
        //   AppRouteController.goBack(context);
        // }
      }
  }
  static getNotificationsCount()async{
      const url = "${AppConfig.host}/users/get/notification/count";
      final response = await http.get(
        Uri.parse(url),
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
      );
      var result = ApiResponse.fromJson(jsonDecode(response.body));
      var count = 0;
      if(AuthController.checkAuthenticationBG(result)){
        count = result.data['count'];
        Console.log("Running counts");
        Console.log(result.data);
      }
        // DataManager.saveUserData(user);
        DataManager.notificationNotifier.value = count;
        // return user;
  }
  static Future<List<AppNotification>> getNotifications(BuildContext context)async{
      const url = "${AppConfig.host}/users/get/notification";
      List<AppNotification> notifies = [];
      final response = await http.get(
        Uri.parse(url),
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
      );
      Console.log(response);
      var result = ApiResponse.fromJson(jsonDecode(response.body));
      var count = 0;
      if(AuthController.checkAuthentication(result, context)){
        count = result.data['count'];
        DataManager.notificationNotifier.value = count;
        notifies = (result.data['notifications'] as List).map<AppNotification>((e) => AppNotification.fromjson(e)).toList();
      }
        // DataManager.saveUserData(user);
        return notifies;
  }
  static readNotification(BuildContext context, String id)async{
      const url = "${AppConfig.host}/user/read/notification";
      final response = await http.post(
        Uri.parse(url),
        body: {"notification":id},
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
      );

      // Console.log(response);
      var result = ApiResponse.fromJson(jsonDecode(response.body));
      // if(AuthController.checkAuthentication(result, context)){
      //   Notify(
      //     context: context,
      //     type:result.success ? 'success' : 'error',
      //     message: result.message,
      //     messageType: Notify.APINOTIFICATION
      //   );
        // if(result.success) {
        //   if(result.data["match"] != null)AppRouteController.gotoConnectScreen(context,result.data['match']);
        // }else {
        //   AppRouteController.goBack(context);
        // }
      // }
  }
  
}