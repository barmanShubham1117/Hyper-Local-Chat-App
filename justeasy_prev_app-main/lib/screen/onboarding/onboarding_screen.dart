import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/controllers/asset_controller.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/preference_manager.dart';
import 'package:justeasy/routes/route_controller.dart';
import 'package:justeasy/screen/onboarding/onboarding_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
class OnbordingScreen extends StatefulWidget {
  @override
  _OnbordingScreenState createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {

  final PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
   _pageController.dispose();
    super.dispose();
  }
  void nextPage(BuildContext context)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(PreferenceManager.IS_FIRST_TIME, false);
    AppRouteController.gotoLoginPage(context);
  }
  @override
  Widget build(BuildContext context) {

    ScreenUtil.setContext(context);

    final Constants constants = Constants(context);
    final double width = constants.screenWidth;
    final double height = constants.screenHeight;
    final textTheme =  constants.textTheme;

    return Scaffold(
      backgroundColor: AppColors.secondaryBG,
      body: Column(
        children: [
          Container(
            width: constants.screenWidth,
            height: constants.screenHeight * 0.8,
            child: PageView(
              children: [
                //  Page 1
                OnBoardingWidget(constant: constants,image: AssetController.firstOnBoarding,text: 'Welcome to our professional community',),
                OnBoardingWidget(constant: constants,image: AssetController.secondOnBoarding,text: 'Find people \nand see who\'s around you',),
              ],
              scrollDirection: Axis.horizontal,
              controller: _pageController,
            ),
          ),
         Container(
           alignment: Alignment.centerRight,
           margin: EdgeInsets.only(right: constants.screenWidth * 0.12, top: constants.screenHeight * 0.05),
           child:  InkWell(
              onTap: (){
                _pageController.page! < 1.0 ? _pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.ease) : nextPage(context);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.primaryText,
                  shape: BoxShape.circle,
                ),
                child: Image.asset("assets/images/right.png", width: constants.screenWidth * 0.05,),
              ),
            ),
         ),
        ],
      ),
      // floatingActionButton: InkWell(
      //   onTap: (){
      //     _pageController.page! < 1.0 ? _pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.ease) : nextPage(context);
      //   },
      //   child: Container(
      //     padding: const EdgeInsets.all(10),
      //     decoration: const BoxDecoration(
      //       color: AppColors.primaryText,
      //       shape: BoxShape.circle,
      //     ),
      //     child: Image.asset("assets/images/right.png", width: constants.screenWidth * 0.05,),
      //   ),
      // ),
      // bottomSheet:BottomSheet(
      //   builder: (context){
      //     return Container(
      //       color:AppColors.secondaryBG,
      //       width: constants.screenWidth,
      //       height: constants.screenHeight * 0.1,
      //     );
      //   }, onClosing: () {  },
      // )
    );
  }

}
