import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:justeasy/controllers/db_connector.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/notify.dart';
import 'package:justeasy/helpers/preference_manager.dart';
import 'package:justeasy/models/api_response.dart';
import 'package:justeasy/routes/route_controller.dart';
import 'package:justeasy/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screen_loader/screen_loader.dart';

class AuthController {
  static sendOTP(
      BuildContext context, String email, ValueNotifier<bool> otpListner) async{
         Console.log("reached");
    // otpListner.value = false;
    BuildContext dialog = context;
    showDialog(context: context, builder: (context){
      dialog = context;
      return Loading();
    });
    ApiResponse response = await DbConnector.generateLoginRequest(email);
    Navigator.pop(dialog);
  //   AppRouteController.showLoadingScreen(context, response, (value) {
  //     AppRouteController.goBack(context);
  //     Notify(
  //         context: context,
  //         type: value.success ? 'success' : 'error',
  //         message: value.message,
  //         messageType: Notify.APINOTIFICATION);
  //         // otpListner.value = true;
  //     // Navigator.pop(context);
  //     if (value.success) AppRouteController.gotoVerifyPage(context, email);
  //   });
  AppRouteController.goBack(context);
      Notify(
          context: context,
          type: response.success ? 'success' : 'error',
          message: response.message,
          messageType: Notify.APINOTIFICATION);
          // otpListner.value = true;
      // Navigator.pop(context);
      if (response.success) AppRouteController.gotoVerifyPage(context, email);
  }

  static resendOTP(
      BuildContext context, String email) async{
         Console.log("reached");
    // otpListner.value = false;
     BuildContext dialog = context;
    showDialog(context: context, builder: (context){
      dialog = context;
      return Loading();
  });
    ApiResponse response = await DbConnector.generateLoginRequest(email);
    Navigator.pop(dialog);
  //   AppRouteController.showLoadingScreen(context, response, (value) {
  //     AppRouteController.goBack(context);
      Notify(
          context: context,
          type: response.success ? 'success' : 'error',
          message: response.message,
          messageType: Notify.APINOTIFICATION);
          // otpListner.value = true;
      // Navigator.pop(context);
      // if (value.success) AppRouteController.gotoVerifyPage(context, email);
    // });
  // AppRouteController.goBack(context);
  //     Notify(
  //         context: context,
  //         type: response.success ? 'success' : 'error',
  //         message: response.message,
  //         messageType: Notify.APINOTIFICATION);
  //         // otpListner.value = true;
  //     // Navigator.pop(context);
  //     if (response.success) 
      // AppRouteController.gotoVerifyPage(context, email);
  }

  static verifyOTP(BuildContext context, String code) async {
    Constants constant = Constants(context);
    BuildContext dialog = context;
    showDialog(context: context, builder: (context){
      dialog = context;
      return Loading();
    });
    var value = await DbConnector.verifyLoginRequest(
        constant.passedData['email'] ?? '', code);
    // AppRouteController.showLoadingScreen(context, response, (value)async{
    // AppRouteController.goBack(context);
    Navigator.pop(dialog);
    Notify(
        context: context,
        type: value.success ? 'success' : 'error',
        message: value.message,
        messageType: Notify.APINOTIFICATION);


    //if userdetail is null pass to verify screen else goto profile.
    if (value.success) {
      var detail = value.data['user'];
      var preferences = await SharedPreferences.getInstance();
      var manager = PreferenceManager(preferences);
      manager.token = value.data["token"];
      // if(detail == null){
      //   AppRouteController.gotoAccountVerifyPage(context);
      // }else {
      AppRouteController.gotoProfilePage(context, afterLogin: true);
      // }
    }
    // });
  }

  static registerUser(BuildContext context, GlobalKey<FormState> _formKey,Map<String, String> args) async {
    if (_formKey.currentState!.validate()) {
      var result = await DbConnector.register(args);
      Notify(
          context: context,
          type: result.success ? 'success' : 'error',
          message: result.message,
          messageType: Notify.APINOTIFICATION);
      if (result.success) AppRouteController.gotoLoginPage(context);
    } else {
      Notify(
          context: context,
          type: 'error',
          message: 'Something went wrong...',
          messageType: Notify.TEXTNOTIFICATION);
    }
  }

  static logout(BuildContext context) async {
    var _preference = PreferenceManager(await SharedPreferences.getInstance());
    var result = await DbConnector.logout();
    // if(AuthController.checkAuthentication(result, context)){
    Notify(
        context: context,
        type: result.success ? 'success' : 'error',
        message: result.message,
        messageType: Notify.APINOTIFICATION);
    if (result.success) {
      _preference.logout();
      // AppRouteController.gotoLoginPage(context);
    }
    AppRouteController.gotoLoginPage(context);
    // }
  }

  static logoutOffline(BuildContext context) async {
    var _preference = PreferenceManager(await SharedPreferences.getInstance());
    _preference.logout();
    AppRouteController.gotoLoginPage(context);
  }

  static checkAuthentication(ApiResponse result, BuildContext context) {
    bool au = result.data['unauthenticated'] ?? false;
    if (au) AuthController.logoutOffline(context);
    return !au;
  }
  static checkAuthenticationBG(ApiResponse result) {
    bool au = result.data['unauthenticated'] ?? false;
    if (au){
      FlutterBackgroundService().stopBackgroundService();
    }
    return !au;
  }
}
