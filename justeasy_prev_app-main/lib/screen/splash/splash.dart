import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:justeasy/controllers/nearby_controller.dart';
import 'package:justeasy/controllers/profile_controller.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/controllers/asset_controller.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/helpers/preference_manager.dart';
import 'package:justeasy/models/user.dart';
import 'package:justeasy/routes/route_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  Splash({ Key? key }) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  late SharedPreferences preference ; 

 @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) => removeSplashScreen());
  }

  void removeSplashScreen(BuildContext context)async {
    preference = await SharedPreferences.getInstance();
    if(preference.getBool(PreferenceManager.IS_FIRST_TIME)??true){
      await Future.delayed(const Duration(seconds: 2));
      AppRouteController.gotoOnboardingScreen(context);
    }else {
      var token = preference.getString(PreferenceManager.AUTHORIZATION_TOKEN);
      if(token != null && token != '') {
        // DataManager.saveUserData(user);
        DataManager.token = await PreferenceManager.getToken();
        // await DataManager.initializeLocationService();
        // await NearByController.getCurrentLocation();
        DataManager.user = await ProfileController.getProfile(context);
        Console.log("user id on splash ${DataManager.user.id}");
        AppRouteController.gotoNearByScreen(context);
      }else {
        AppRouteController.gotoLoginPage(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Constants constant = Constants(context);
    ScreenUtil.setContext(context);
    removeSplashScreen(context);
    return Container(
      width: constant.screenWidth,
      height: constant.screenHeight,
      color: AppColors.primaryBG,
      // decoration: BoxDecoration(
      //    gradient: LinearGradient(
      //         colors: [Color(0xFF98C1D9), Color(0xFF6AD8AC)],
      //         begin: Alignment.topCenter,
      //         end: Alignment.bottomCenter,
      //       ),
      // ),
      child: Center(
        child: Container(
          child: Container(
          width: constant.screenWidth * 0.5,
          height: constant.screenWidth * 0.5,
          padding: EdgeInsets.only(left:constant.screenWidth * 0.1, right:constant.screenWidth * 0.1),
          decoration:BoxDecoration(
            color: AppColors.secondaryBG,
            // gradient: LinearGradient(
            //   colors: [Color(0xFF98C1D9), Color(0xFF6AD8AC).withOpacity(0.6)],
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            // ),
            // color: AppColors.secondaryBG,
            // borderRadius: BorderRadius.circular(30),
            // boxShadow: [
            //   BoxShadow(
            //     offset: Offset(3,4),
            //     blurRadius: 16,
            //     spreadRadius: 0,
            //     color: Color(0xFF88A5BF).withOpacity(0.54),
            //     // color: Gra
            //   ),
            //   BoxShadow(
            //     offset: Offset(0,0),
            //     blurRadius: 0,
            //     spreadRadius: 0,
            //     color: Colors.white,
            //     // color: Gra
            //   ),
            // ],
            shape: BoxShape.circle
          ),
          child: const Center(
            child: Image(
              image: AssetController.getLogo,
            ),
          ),
        ),
      ),
    ),
        );
  }
}