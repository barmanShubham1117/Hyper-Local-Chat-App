import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:justeasy/controllers/profile_controller.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/helpers/preference_manager.dart';
import 'package:justeasy/models/api_response.dart';
import 'package:justeasy/models/social.dart';
import 'package:justeasy/models/user.dart';
import 'package:justeasy/routes/route_names.dart';
import 'package:justeasy/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouteController {

  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }
  // static void resetApp(BuildContext context){
  //   Navigator.of(context).popAndPushNamed(AppRouteName.loginPage);
  // }
  static void gotoOnboardingScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(AppRouteName.onboardingScreen);
  }
  static void gotoRegisterPage(BuildContext context,{String email = ''}) {
    Navigator.of(context).pushNamed(AppRouteName.registerPage,arguments: {'email':email});
  }
  static void gotoLoginPage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(AppRouteName.loginPage);
  }
  static void gotoSocialLoginPage(BuildContext context) {
    Navigator.of(context).pushNamed(AppRouteName.socialLoginWeb);
  }
  static void gotoAuthPage(BuildContext context) {
    Navigator.of(context).pushNamed(AppRouteName.authPage);
  }
  static void gotoVerifyPage(BuildContext context, String email) {
    Navigator.of(context).pushNamed(AppRouteName.verifyPage,arguments: {'email':email});
  }
  static void gotoProfilePage(BuildContext context,{bool afterLogin = false}) async{
     BuildContext dialog = context;
    showDialog(context: context, builder: (context){
      dialog = context;
      return Loading();
    });
  DataManager.user = await ProfileController.getProfile(context);
    Navigator.pop(dialog);
    if(afterLogin) {
      Navigator.of(context).popUntil(ModalRoute.withName(AppRouteName.loginPage));
      Navigator.of(context).pushReplacementNamed(AppRouteName.profilePage,arguments: {'afterLogin':afterLogin});
    }else{
      Navigator.of(context).pushNamed(AppRouteName.profilePage,arguments: {'afterLogin':afterLogin});
    } 
  }
  static void gotoNearByScreen(BuildContext context) async{
    User user = await ProfileController.getProfile(context);
    Navigator.of(context).popAndPushNamed(AppRouteName.nearby,arguments: {'user':user});
  }
  static void gotoConnectScreen(BuildContext context, User second, Map<String,dynamic> match, String second_id) async{
    Navigator.of(context).popUntil(ModalRoute.withName(AppRouteName.nearby));
    Navigator.of(context).pushNamed(AppRouteName.connect, arguments: {"match":match,"second":second,"second_id":second_id});
  }
  static void gotoChatScreen(BuildContext context, Map<String,dynamic> room, User second,{Social? social}) async{
    Navigator.of(context).popUntil(ModalRoute.withName(AppRouteName.nearby));
    Navigator.of(context).pushNamed(AppRouteName.chat, arguments: {"room":room,"second":second,"social":social});
  }
  static void gotoNotificationScreen(BuildContext context) async{
    Navigator.of(context).pushNamed(AppRouteName.notification);
  }
  static void gotoConnectionRequestScreen(BuildContext context, User user, String match, String second) async{
    Navigator.of(context).popUntil(ModalRoute.withName(AppRouteName.nearby));
    Navigator.of(context).pushNamed(AppRouteName.connectionRequest, arguments: {'user':user,'match':match,'second':second});
  }
  static void gotoAccountVerifyPage(BuildContext context) async{
    String token = await PreferenceManager.getToken();
    Navigator.of(context).pushReplacementNamed(AppRouteName.accountVerifyPage, arguments: {'token':token});
  }

  static void showLoadingScreen(BuildContext context, Future<dynamic> whenClose, Function actionFunction) {
    Navigator.of(context).pushNamed(AppRouteName.loadingPage,arguments: {'whenclose':whenClose,'actionFunction':actionFunction});
  }
  static void gotoSettingScreen(BuildContext context) {
    Navigator.of(context).pushNamed(AppRouteName.settingScreen);
  }
  static void gotoShareScreen(BuildContext context) {
    Navigator.of(context).pushNamed(AppRouteName.shareScreen);
  }
}