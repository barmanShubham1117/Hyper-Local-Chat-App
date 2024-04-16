import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/text_style.dart';
import 'package:justeasy/routes/route_controller.dart';

class Buttons{
  static Widget smallButton(BuildContext context ,Constants constant, String text, Function onClick , {double multiplyer = 1} ) => InkWell(
                        onTap: (){
                          onClick(context);
                        },
                        child: Container(
                          width: constant.screenWidth * 0.36,
                          height:constant.screenHeight * 0.06,
                          // margin: EdgeInsets.all(8),
                          // padding: EdgeInsets.only(
                          //   left: constant.screenWidth * 0.1, 
                          //   right: constant.screenWidth * 0.1,
                          //   top: constant.screenWidth * 0.035,
                          //   bottom: constant.screenWidth * 0.035,
                          //   ),
                          decoration: BoxDecoration(
                            color: AppColors.buttonColor,
                            borderRadius: BorderRadius.circular(constant.screenWidth * multiplyer),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.4),
                            //     blurRadius: 2,
                            //     offset: Offset(10,10),
                            //   ),
                            // ],
                          ),
                          child: Center(
                            child:Text(
                              text,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: AppColors.primarybuttonText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp)
                                     ),
                            ),
                          ),
                        ),
                      );
  static Widget largeButton(BuildContext context, Constants constant, String text, Function onClick, {bool enabled=true, double? width, Color? background, bool shader = false, Color textColor = AppColors.primarybuttonText, double multiplyer = 1 } ) => InkWell(
                        onTap: (){
                          if(enabled)onClick(context);
                        },
                        child: Container(
                          width: width ?? 250.w,
                          height:35.h,
                          padding: EdgeInsets.only(
                            // left: constant.screenWidth * 0.1, 
                            // right: constant.screenWidth * 0.1,
                            // top: constant.screenWidth * 0.03,
                            // bottom: constant.screenWidth * 0.03,
                            ),
                          decoration: BoxDecoration(
                            color: enabled ? background ??AppColors.buttonColor : AppColors.primaryBG,
                            borderRadius: BorderRadius.circular(constant.screenWidth * multiplyer),
                            boxShadow: shader 
                            ? [
                              BoxShadow(
                                color:Colors.black.withOpacity(0.1),
                                blurRadius: 3,
                                spreadRadius: 0,
                                offset: Offset(3,3)
                              ),
                            ]
                            :[],
                          ),
                          child: Center(
                            child: Text(
                              text,
                              
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                 color: textColor,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 18.sp)
                                ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
  static Widget socialButton(BuildContext context, Constants constant, String text, AssetImage image, Function onClick,{double multiplyer = 1} ) => InkWell(
                        onTap: (){
                          onClick(context);
                        },
                        child: Container(
                          width: 250.w,
                          height: 35.h,
                          padding: EdgeInsets.only(
                            // left: constant.screenWidth * 0.1, 
                            // right: constant.screenWidth * 0.1,
                            // top: constant.screenWidth * 0.03,
                            // bottom: constant.screenWidth * 0.03,
                            ),
                          decoration: BoxDecoration(
                            color: AppColors.buttonColor,
                            borderRadius: BorderRadius.circular(constant.screenWidth * multiplyer),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image:image,
                                width: constant.screenWidth * 0.05,
                              ),
                              Text(
                                " $text",
                                style: AppTextStyle.socialButton(constant),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      );
  static Widget backButton(BuildContext context, {bool visible=true}) => Visibility(
    visible: visible,
    child: IconButton(
      onPressed: (){
        AppRouteController.goBack(context);
      },
      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.secondaryText,),
    ),
  );
}
