import 'dart:convert';

import 'package:background_location/background_location.dart' as LocationBG;
import 'package:flutter/widgets.dart';
import 'package:justeasy/config/app_config.dart';
import 'package:justeasy/controllers/auth_controller.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/helpers/notify.dart';
import 'package:justeasy/helpers/preference_manager.dart';
import 'package:justeasy/models/api_response.dart';
import 'package:justeasy/models/local_notification.dart';
import 'package:justeasy/models/user.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class NearByController{
  
  static Future<LocationData?> getCurrentLocation()async{
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

  //   if(await location.isBackgroundModeEnabled())location.enableBackgroundMode(enable:true);
  //   _locationData = await location.getLocation();
  //   return _locationData;
  }

  static void updateLocation(User user, Location location)async{
     
    var currentLocation = DataManager.location;
    var _locationData = await NearByController.getCurrentLocation();
    if(_locationData != null){
      if(_locationData.latitude != currentLocation['latitude'] || _locationData.longitude != currentLocation['longitude'] || _locationData.altitude != currentLocation['altitude']){
          const url = "${AppConfig.host}/profile/update/location";
          final response = await http.post(
             Uri.parse(url),
             body: {
               'latitude':"${_locationData.latitude}",
               'longitude':"${_locationData.longitude}",
               'altitude':"${_locationData.altitude}"
             },
             headers: AppConfig.getApiHeader(await PreferenceManager.getToken()));
          //  Console.log(response.body);

          // var result = ApiResponse.fromJson(jsonDecode(response.body));
      }else{
        Console.log('No change in location.');
      }
    }else{
      Console.log('Location is null');
    }
  }
  static void updateLocationBG(User user, LocationBG.Location location)async{
     
     Console.log("Updating location.");
    var currentLocation = DataManager.location;
    // bool _serviceEnabled = await Location().serviceEnabled();
    final LocationBG.Location _locationData = location;

    // final BackgroundLocation _locationData = location;
    if(_locationData != null){
      if(_locationData.altitude != currentLocation['latitude'] || _locationData.longitude != currentLocation['longitude'] || _locationData.altitude != currentLocation['altitude']){
          const url = "${AppConfig.host}/profile/update/location";
          final response = await http.post(
             Uri.parse(url),
             body: {
               'latitude':"${_locationData.latitude}",
               'longitude':"${_locationData.longitude}",
               'altitude':"${_locationData.altitude}"
             },
             headers: AppConfig.getApiHeader(await PreferenceManager.getToken()));
          //  Console.log(response.body);

          var result = ApiResponse.fromJson(jsonDecode(response.body));
          if(result.success){
            currentLocation["latitude"] =  _locationData.latitude??0;
            currentLocation["longitude"] = _locationData.longitude??0;
            currentLocation["altitude"] =  _locationData.altitude??0;
            DataManager.location = currentLocation;

          }
      }else{
        Console.log('No change in location.');
      }
    }else{
      Console.log('Location is null');
    }
  }

  // static Future<List<User>> getNearbyUsers()async{
  static Future<ApiResponse> getNearbyUsers()async{
      const url = "${AppConfig.host}/users/nearby";
      final response = await http.get(
        Uri.parse(url),
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
      );
      // Console.log(response.body);
      var result = ApiResponse.fromJson(jsonDecode(response.body));
      List<User> list = [];
      // if(AuthController.checkAuthentication(result, context)){
        // Notify(
        //   context: context,
        //   type:result.success ? 'success' : 'error',
        //   message: result.message,
        //   messageType: Notify.APINOTIFICATION
        // );
        // Console.log(result.data['users'][0] as Map<String, dynamic>);
        // list = (result.data['users'] as List).map<User>((json)=>User.fromJson(json)).toList();
        // Console.log(list);
      // }
      return result;
  }
  static Future<List<User>> getNearbyUsersBG()async{
      const url = "${AppConfig.host}/users/nearby";
      final response = await http.get(
        Uri.parse(url),
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
      );
      // Console.log(response.body);
      var result = ApiResponse.fromJson(jsonDecode(response.body));
      List<User> list = [];
      if(AuthController.checkAuthenticationBG(result)){
        //  Notify(
        //    context: context,
        //    type:result.success ? 'success' : 'error',
        //    message: result.message,
        //    messageType: Notify.APINOTIFICATION
        //  );
        //  Console.log(result.data['users'][0] as Map<String, dynamic>);
         list = (result.data['users'] as List).map<User>((json)=>User.fromJson(json)).toList();
         Console.log(list);
       }
        // Console.log(list);
      // }
      return list;
  }
  static Future<List<User>> getGpsUsersBG()async{
      const url = "${AppConfig.host}/users/gps";
      final response = await http.get(
        Uri.parse(url),
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
      );
      // Console.log(response.body);
      var result = ApiResponse.fromJson(jsonDecode(response.body));
      List<User> list = [];
      if(AuthController.checkAuthenticationBG(result)){
        //  Notify(
        //    context: context,
        //    type:result.success ? 'success' : 'error',
        //    message: result.message,
        //    messageType: Notify.APINOTIFICATION
        //  );
        //  Console.log(result.data['users'][0] as Map<String, dynamic>);
         list = (result.data['users'] as List).map<User>((json)=>User.fromJson(json)).toList();
         Console.log(list);
       }
        // Console.log(list);
      // }
      return list;
  }

  static getUserByID(BuildContext context, String id)async{
      const url = "${AppConfig.host}/user/get";
      final response = await http.post(
        Uri.parse(url),
        body: {"id":id},
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
      );
      var result = ApiResponse.fromJson(jsonDecode(response.body));
      if(AuthController.checkAuthentication(result, context)){
        if(result.success){
          User user = User.fromJson(result.data["detail"]);
          return user;
        }else{
          Notify(
            context: context,
            type:result.success ? 'success' : 'error',
            message: result.message,
            messageType: Notify.APINOTIFICATION
          );
        }
        // Console.log(result.data['users'][0] as Map<String, dynamic>);
        // list = (result.data['users'] as List).map<User>((json)=>User.fromJson(json)).toList();
        // Console.log(list);
      }
  }
  
  static Future<ApiResponse>blockUser(BuildContext context, String id)async{
      const url = "${AppConfig.host}/user/block";
      final response = await http.post(
        Uri.parse(url),
        body: {"id":id},
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
      );
      var result = ApiResponse.fromJson(jsonDecode(response.body));
      if(AuthController.checkAuthentication(result, context)){
        Notify(
            context: context,
            type:result.success ? 'success' : 'error',
            message: result.message,
            messageType: Notify.APINOTIFICATION
          );
        // Console.log(result.data['users'][0] as Map<String, dynamic>);
        // list = (result.data['users'] as List).map<User>((json)=>User.fromJson(json)).toList();
        // Console.log(list);
      }
      return result;
  }
  static Future<ApiResponse> unBlockUser(BuildContext context, String id)async{
      const url = "${AppConfig.host}/user/un/block";
      final response = await http.post(
        Uri.parse(url),
        body: {"id":id},
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
      );
      var result = ApiResponse.fromJson(jsonDecode(response.body));
      if(AuthController.checkAuthentication(result, context)){
        Notify(
            context: context,
            type:result.success ? 'success' : 'error',
            message: result.message,
            messageType: Notify.APINOTIFICATION
          );
        // Console.log(result.data['users'][0] as Map<String, dynamic>);
        // list = (result.data['users'] as List).map<User>((json)=>User.fromJson(json)).toList();
        // Console.log(list);
      }
      return result;
  }
  static Future<List<dynamic>> getBlockUser(BuildContext context)async{
      const url = "${AppConfig.host}/user/get/block";
      final response = await http.get(
        Uri.parse(url),
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
      );
      var result = ApiResponse.fromJson(jsonDecode(response.body));
      List<dynamic> list = [];
      if(AuthController.checkAuthentication(result, context)){
        // Notify(
        //     context: context,
        //     type:result.success ? 'success' : 'error',
        //     message: result.message,
        //     messageType: Notify.APINOTIFICATION
        //   );
        // Console.log(result.data['users'][0] as Map<String, dynamic>);
        list = result.data['block'];
        // Console.log(list);
      }
      return list;
  }
  
}