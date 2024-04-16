import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:justeasy/controllers/auth_controller.dart';
import 'package:justeasy/controllers/db_connector.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/controllers/asset_controller.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/notify.dart';
import 'package:justeasy/helpers/preference_manager.dart';
import 'package:justeasy/routes/route_controller.dart';
import 'package:justeasy/widgets/buttons.dart';
import 'package:justeasy/widgets/pin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Verification extends StatelessWidget {
  Verification({ Key? key }) : super(key: key);

late Pin pin ;
bool ispin = false ;
void goForward(context)async{
      AuthController.verifyOTP(context, pin.getCode());
    }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);
    Widget pinMaker(constant){
      ispin = true;
      pin = Pin(
            constant: constant,
            length: 6,
        );
      return pin;
    }
    ScreenUtil().setHeight(689);
    ScreenUtil().setWidth(360);
    Constants constant = Constants(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.primaryBG,
        body: SingleChildScrollView(
          child:Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                  padding: EdgeInsets.only(
                    left: 20.w, 
                    right: constant.screenWidth * 0.1, 
                    // bottom: constant.screenWidth * 0.05
                  ),
                  // width: constant.screenWidth,
                  // height: constant.screenHeight * 0.2,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBG,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.w),
                      bottomRight: Radius.circular(10.w)
                    )
                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BackButton(),
                      Text(
                        'Verification',
                        style: constant.textTheme.headline3,
                      ),
                      Text(
                        'Enter the 6 digit code that has been sent on ${constant.passedData['email']??''}.',
                        // textAlign: TextAlign.justify,
                        style: constant.textTheme.subtitle1?.copyWith(
                          color: AppColors.secondaryText.withOpacity(0.49),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
            Stack(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top:constant.screenHeight * 0.03),
                    width: 280.w,
                    height: 310.h,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBG,
                      borderRadius: BorderRadius.circular(20.w)
                    ),
                  ),
                ),
               Center(
                 child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image(
                        image: AssetController.thirdOnBoarding,
                        width: 200.w,
                      ),
                      SizedBox(
                         height:10.h,
                       ),
                       ispin ? pin : pinMaker(constant),
                       SizedBox(
                         height:10.h,
                       ),
                      Buttons.largeButton(context, constant, 'VERIFY', goForward),
                      SizedBox(
                         height:10.h,
                       ),
                      InkWell(
                        onTap: ()=>AuthController.resendOTP(context, "${constant.passedData['email']??''}"),
                        child: RichText(
                        text:TextSpan(
                          text: 'Didn\'t receive OTP?',
                              children: [
                                TextSpan(
                                  text:' Resend code?',
                                  style: constant.textTheme.subtitle2?.copyWith(
                                    leadingDistribution: TextLeadingDistribution.even,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.placeholderColor.withOpacity(0.8),
                                    color: AppColors.placeholderColor.withOpacity(0.8),
                                    textBaseline: TextBaseline.alphabetic,
                                    fontSize: 15.sp
                                  ),
                                )
                              ],
                              style: constant.textTheme.subtitle2?.copyWith(
                                color: AppColors.placeholderColor.withOpacity(0.8),
                                fontSize: 16.sp
                              ),
                            ), 
                          ),
                      ),
                    ],
                  ),
               ),
              ],
            ),
          ],
        ),
      
        ),
      ),
    );
  }
}