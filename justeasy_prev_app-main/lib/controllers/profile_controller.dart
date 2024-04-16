import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justeasy/config/app_config.dart';
import 'package:justeasy/controllers/asset_controller.dart';
import 'package:justeasy/controllers/auth_controller.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/helpers/notify.dart';
import 'package:justeasy/helpers/preference_manager.dart';
import 'package:justeasy/models/api_response.dart';
import 'package:justeasy/models/local_notification.dart';
import 'package:justeasy/models/social.dart';
import 'package:justeasy/models/user.dart';
import 'package:justeasy/routes/route_controller.dart';
import 'package:http/http.dart' as http;
import 'package:justeasy/widgets/loading.dart';
import 'package:location/location.dart';

class ProfileController {
  static void captureImage(
      ValueNotifier<String> imageNotifier, bool network) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 10);
    final path = image != null ? image.path : AssetController.dummyProfile;
    network = false;
    imageNotifier.value = path;
  }

  static void updateProfile(BuildContext context, GlobalKey<FormState> _formKey,
      Map<String, String> args, String path) async {
    if (_formKey.currentState!.validate()) {
      BuildContext dialog = context;
    showDialog(context: context, builder: (context){
      dialog = context;
      return Loading();
    });
      var url = Uri.parse("${AppConfig.host}/profile/update");
      final request = http.MultipartRequest('POST', url);
      try {
        request.files.add(await http.MultipartFile.fromPath("image", path));
      } catch (e) {
        Console.log('ProfileController:34:unable to fetch image');
      }
      request.headers.addAll(
          AppConfig.getApiHeader(await PreferenceManager.getToken()));
      request.fields.addAll(args);
      // final response = await http.post(
      //   Uri.parse(url),
      //   body: args,
      //   headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
      // );
      final response = await request.send();
      response.stream.transform(utf8.decoder).listen((event) {
        Console.log(event);
        var result = ApiResponse.fromJson(jsonDecode(event));
        if (AuthController.checkAuthentication(result, context)) {
          Notify(
              context: context,
              type: result.success ? 'success' : 'error',
              message: result.message,
              messageType: Notify.APINOTIFICATION);
          if(result.success) {
           if(path != ''){
              DataManager.profileTimer?.cancel();
              DataManager.profileTimer = Timer(const Duration(seconds: 7200),(){
                ProfileController.getProfile(context).then((value) {
                  getProfile(context);
                  AppRouteController.gotoNearByScreen(context);
                });
                LocalNotification notifyLocal = LocalNotification(context);
                notifyLocal.showNotification(
                  channel: "${DataManager.user.id}-timeout-channel", 
                  channelDescription: "Notify when your session timeout.", 
                  channelName: "Session timeout", 
                  title: "Session out.", 
                  body: "Your profile is no more visible to others,Please Update your profile selfie."
                );
              });
           }
            ProfileController.getProfile(context).then((value) {
              getProfile(context);
              AppRouteController.gotoNearByScreen(context);
            });
          }
        }
      });

    Navigator.pop(dialog);
    }
  }

  static Future<User> getProfile(BuildContext context) async {
    const url = "${AppConfig.host}/profile/get";
    final response = await http.get(
      Uri.parse(url),
      headers:
          AppConfig.getApiHeader(await PreferenceManager.getToken()),
    );
    Console.log(response.body, r: true);
    var result = ApiResponse.fromJson(jsonDecode(response.body));
    var user;
    if (AuthController.checkAuthentication(result, context)) {
      // Notify(
      //   context: context,
      //   type:result.success ? 'success' : 'error',
      //   message: result.message,
      //   messageType: Notify.APINOTIFICATION
      // );
      user = result.success
          ? User.fromJson(result.data['user'])
          : User(
              distance: 0,
              dateOfBirth: '',
              id: '',
              userName: '',
              name: '',
              nickName: '',
              email: '',
              location: '',
              status: '',
              image: '',
              user_id: '',
              points: LocationData.fromMap({
                'latitude': 0,
                'longitude': 0,
                'altitude': 0,
              }));
    }
    // DataManager.saveUserData(user);
    DataManager.user = user;
    return user;
  }
  static Future<List<Social>> getSocials(BuildContext context) async {
    const url = "${AppConfig.host}/profile/get/social";
    final response = await http.get(
      Uri.parse(url),
      headers:
          AppConfig.getApiHeader(await PreferenceManager.getToken()),
    );
    Console.log(response.body, r: true);
    var result = ApiResponse.fromJson(jsonDecode(response.body));
    List<Social> social = [];
    if (AuthController.checkAuthentication(result, context)) {
      social = (result.data["social"] as List).map<Social>((e) => Social.fromJson(e)).toList();
    }
    return social;
  }
  static Future<List<Social>> getActiveSocials(BuildContext context) async {
    const url = "${AppConfig.host}/profile/active/social";
    final response = await http.get(
      Uri.parse(url),
      headers:
          AppConfig.getApiHeader(await PreferenceManager.getToken()),
    );
    Console.log(response.body, r: true);
    var result = ApiResponse.fromJson(jsonDecode(response.body));
    List<Social> social = [];
    if (AuthController.checkAuthentication(result, context)) {
      social = (result.data["social"] as List).map<Social>((e) => Social.fromJson(e)).toList();
    }
    return social;
  }

  static addSocial(BuildContext context, String name, String value, int icon, ValueNotifier notifier)async{
    const url = "${AppConfig.host}/profile/save/social";
      final response = await http.post(
        Uri.parse(url),
        body: {
          "social_platform":"$icon",
          "profile_link":value,
          "name":name
        },
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
      );

      Console.log(response.body);
      var result = ApiResponse.fromJson(jsonDecode(response.body));
      Console.log(result.data);
      if(AuthController.checkAuthentication(result, context)){
        Notify(
          context: context,
          type:result.success ? 'success' : 'error',
          message: result.message,
          messageType: Notify.APINOTIFICATION
        );
        // if(result.success)notifier.value = !notifier.value;
        Navigator.pop(context);
      }
  }
  static updateSocial(BuildContext context, Social social, ValueNotifier<bool> notifier)async{
    const url = "${AppConfig.host}/profile/update/social";
      final response = await http.post(
        Uri.parse(url),
        body: {
          "social_platform":"${social.type}",
          "profile_link":social.value,
          "name":social.name,
          "social":social.id,
          "status":"${notifier.value}"
        },
        headers: AppConfig.getApiHeader(await PreferenceManager.getToken()),
      );

      Console.log(response.body);
      var result = ApiResponse.fromJson(jsonDecode(response.body));
      Console.log(result.data);
      if(AuthController.checkAuthentication(result, context)){
        if(!result.success){
          notifier.value = !notifier.value;
          Notify(
            context: context,
            type:result.success ? 'success' : 'error',
            message: result.message,
            messageType: Notify.APINOTIFICATION
          );
        };
      }
  }

}
