import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justeasy/controllers/asset_controller.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/routes/route_controller.dart';
import 'package:justeasy/widgets/buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatelessWidget {
  LoginPage({ Key? key }) : super(key: key);

void nextPage(context){
      AppRouteController.gotoAuthPage(context);
    }
    void signupPage(context){
      AppRouteController.gotoRegisterPage(context);
    }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);
    ScreenUtil().setWidth(360);
    ScreenUtil().setHeight(689);
    Constants constant = Constants(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin:EdgeInsets.only(top: constant.screenHeight * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: constant.screenHeight * 0.35,
                // padding: EdgeInsets.all(constant.screenWidth * 0.1),
                child: Center(child: Image(image: AssetController.secondOnBoarding,),),
              ),
              Container(
                padding: EdgeInsets.only(left: constant.screenWidth * 0.1, right: constant.screenWidth * 0.09),
                width: constant.screenWidth,
                height: constant.screenHeight * 0.45,
                decoration: BoxDecoration(
                  color: AppColors.primaryBG,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(constant.screenWidth * 0.1),
                    topRight: Radius.circular(constant.screenWidth * 0.1)
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: constant.screenHeight * 0.05,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top:10.h, 
                            right:30.w,
                            left:15.w
                          ),
                        child:Text(
                          'Hello !',
                          style: GoogleFonts.roboto(
                                textStyle:  TextStyle(
                                  color: AppColors.secondaryText,
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 36.sp)
                                 ),
                        ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:10.h, right:30.w,left:15.w),
                          child: Text(
                            'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate',
                            textAlign: TextAlign.justify,
                           style: GoogleFonts.roboto(
                                textStyle:  TextStyle(
                                  color: AppColors.secondaryText,
                                  fontWeight: FontWeight.normal, 
                                  letterSpacing: -1,
                                  fontSize: 18.sp)
                                     ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Buttons.smallButton(context,constant,'Log in',nextPage),
                        ),
                        Center(
                          child: Buttons.smallButton(context,constant,'Sign up',signupPage),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}