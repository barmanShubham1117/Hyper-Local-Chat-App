import 'package:flutter/widgets.dart';
import 'package:justeasy/profile/profile.dart';
import 'package:justeasy/routes/route_names.dart';
import 'package:justeasy/screen/chat_screen.dart';
import 'package:justeasy/screen/connect_screen.dart';
import 'package:justeasy/screen/connection_request.dart';
import 'package:justeasy/screen/login/auth.dart';
import 'package:justeasy/screen/login/login_page.dart';
import 'package:justeasy/screen/nearby.dart';
import 'package:justeasy/screen/notification_screen.dart';
import 'package:justeasy/screen/register/register.dart';
import 'package:justeasy/screen/login/verify.dart';
import 'package:justeasy/screen/onboarding/onboarding_screen.dart';
import 'package:justeasy/screen/settings.dart';
import 'package:justeasy/screen/share.dart';
import 'package:justeasy/screen/social_web.dart';
import 'package:justeasy/screen/splash/splash.dart';
import 'package:justeasy/screen/verify_account.dart';
import 'package:justeasy/widgets/loading.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRouteName.onboardingScreen: (context) => OnbordingScreen(),
      AppRouteName.loginPage: (context) => LoginPage(),
      AppRouteName.authPage: (context) => Authentication(),
      AppRouteName.verifyPage: (context) => Verification(),
      AppRouteName.profilePage: (context) => Profile(),
      AppRouteName.registerPage: (context) => Register(),
      AppRouteName.accountVerifyPage: (context) => VerifyAccount(),
      AppRouteName.socialLoginWeb: (context) => SocialWeb(),
      AppRouteName.loadingPage: (context)=>Loading(),
      AppRouteName.splash: (context)=>Splash(),
      AppRouteName.nearby: (context)=>NearByScreen(),
      AppRouteName.connect: (context)=>ConnectScreen(),
      AppRouteName.chat: (context)=>ChatScreen(),
      AppRouteName.notification: (context)=>NotificationScreen(),
      AppRouteName.connectionRequest: (context)=>ConnectionRequestScreen(),
      AppRouteName.settingScreen: (context)=>SettingScreen(),
      AppRouteName.shareScreen: (context)=>ShareScreen(),
    };
  }
}