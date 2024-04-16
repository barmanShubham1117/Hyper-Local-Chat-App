import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:justeasy/controllers/auth_controller.dart';
import 'package:justeasy/controllers/db_connector.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/controllers/asset_controller.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/helpers/notify.dart';
import 'package:justeasy/helpers/preference_manager.dart';
import 'package:justeasy/models/api_response.dart';
import 'package:justeasy/routes/route_controller.dart';
import 'package:justeasy/widgets/buttons.dart';
import 'package:justeasy/widgets/loading.dart';
import 'package:justeasy/widgets/social_model.dart';


class Authentication extends StatelessWidget {
   Authentication({ Key? key }) : super(key: key);

final TextEditingController emailController = TextEditingController(text: kDebugMode ? DataManager.EMAIL : '');
final GlobalKey emailKey = GlobalKey();
final ValueNotifier<bool> otpListner = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);
    void linkedin(BuildContext context){
      AppRouteController.gotoSocialLoginPage(context);
    }
    void nextPage(context){
      AuthController.sendOTP(context, emailController.text, otpListner);
    }
    Constants constant = Constants(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(140.h),
          child: SingleChildScrollView(
            child:Container(
                padding: EdgeInsets.only(left: constant.screenWidth * 0.05, right: constant.screenWidth * 0.2),
                width: constant.screenWidth,
                height: 140.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryBG,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(constant.screenWidth * 0.07),
                    bottomRight: Radius.circular(constant.screenWidth * 0.08)
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Buttons.backButton(context),
                    Text(
                      'Log In',
                      style: constant.textTheme.headline3,
                    ),
                    
                    Text(
                      'Login with mobile number or continue with Linkedin.',
                      style: constant.textTheme.subtitle1?.copyWith(
                        color: AppColors.secondaryText.withOpacity(0.49),
                      ),
                    ),
                    SizedBox(
                      height:constant.screenHeight * 0.002,
                    ),
                  ],
                ),
              ),
        
          ),
        ),
        body: Container(
          padding:EdgeInsets.only(left: 10,right:10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: constant.screenHeight * 0.05),
                height: constant.screenHeight * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(constant.screenHeight * 0.02),
                      padding: EdgeInsets.only(left:constant.screenHeight * 0.02,right: constant.screenHeight * 0.02),
                      decoration: BoxDecoration(
                        color: AppColors.textFieldBG.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(constant.screenHeight)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.mail_outline,
                            color: AppColors.placeholderColor.withOpacity(0.5),
                          ),
                          Container(
                            // padding: EdgeInsets.only(left: 2),
                            width: constant.screenWidth * 0.7,
                            child: TextFormField(
                              controller: emailController,
                              key:emailKey,
                              cursorColor: AppColors.buttonColor,
                              decoration: InputDecoration(
                                hintText: 'Enter Email ID',
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: AppColors.placeholderColor.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height:constant.screenHeight * 0.07,
                    ),
                    ValueListenableBuilder(
                      valueListenable: otpListner,
                      builder: (context,value,child){
                        return otpListner.value ? Buttons.largeButton(context,constant, 'GET OTP', nextPage) : 
                        Buttons.largeButton(context,constant, 'GET OTP', nextPage, enabled: false);
                      },
                    ),
                     SizedBox(
                        height:constant.screenHeight * 0.03,
                      ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: constant.screenWidth * 0.2,
                            height: constant.screenHeight * 0.002,
                            decoration: BoxDecoration(color: AppColors.mutedColor.withOpacity(0.5)),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: Text(
                              'or',
                              style: TextStyle(color: AppColors.mutedColor),
                              ),
                          ),
                          Container(
                            width: constant.screenWidth * 0.2,
                            height: constant.screenHeight * 0.002,
                            decoration: BoxDecoration(color: AppColors.mutedColor.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height:constant.screenHeight * 0.03,
                    ),
                    Buttons.socialButton(context,constant, ' Continue with linkedin', AssetController.socialLinkedin, linkedin),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

