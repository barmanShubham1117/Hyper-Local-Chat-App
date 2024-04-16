import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/constants.dart';

class AppTextStyle{
  static TextTheme getTextTheme(context) => GoogleFonts.robotoTextTheme(
    Constants(context).textTheme.copyWith(
       headline1: GoogleFonts.workSans(
        textStyle: TextStyle(
         color: AppColors.primaryText,
         fontWeight: FontWeight.w700, 
         letterSpacing: 0.08,
         fontSize: 38)
        ),
       headline2: GoogleFonts.roboto(
         textStyle: TextStyle(
           color: AppColors.secondaryText,
           fontWeight: FontWeight.bold, 
           fontSize: 34)
          ),
       headline3: GoogleFonts.roboto(
         textStyle: TextStyle(
           color: AppColors.secondaryText,
           fontWeight: FontWeight.w500, 
           fontSize: 30)
          ),
       button: GoogleFonts.roboto(
         textStyle: TextStyle(
           color: AppColors.primarybuttonText,
           fontWeight: FontWeight.bold,
           fontSize: 15)
          ),
       subtitle1: GoogleFonts.roboto(
         textStyle: TextStyle(
           color: AppColors.secondaryText,
           fontWeight: FontWeight.normal, 
           fontSize: 18)
          ),
       subtitle2: GoogleFonts.epilogue(
         textStyle: TextStyle(
           color: AppColors.accentText,
           fontWeight: FontWeight.w400, 
           fontSize: 15)
          ),
       bodyText2: GoogleFonts.epilogue(
         textStyle: TextStyle(
           color: AppColors.accentText,
         ),
       ),
          
    )
  );

  static TextStyle headline1(context) => GoogleFonts.epilogue(
    textStyle: TextStyle(
     color: AppColors.primaryText,
     fontWeight: FontWeight.w600, 
     fontSize: 30.sp)
    );
  static TextStyle socialButton(constant) => GoogleFonts.roboto(
    textStyle: TextStyle(
     color: AppColors.placeholderColor,
     fontWeight: FontWeight.normal, 
     fontSize: 15.sp)
    );
  static TextStyle placeholderText(constant) => GoogleFonts.roboto(
    textStyle: TextStyle(
     color: AppColors.primarybuttonText,
     fontWeight: FontWeight.w600, 
     fontSize: 18.sp)
    );
  static TextStyle profileName(constant) => GoogleFonts.epilogue(
    textStyle: TextStyle(
     color: AppColors.secondaryText,
     fontWeight: FontWeight.bold, 
     fontSize: 18.sp)
    );
  static TextStyle profileID(constant) => GoogleFonts.epilogue(
    textStyle: TextStyle(
     color: AppColors.secondaryText,
     fontWeight: FontWeight.w400, 
     fontSize: 13.sp)
    );
  static TextStyle profileSubHeading(constant) => GoogleFonts.epilogue(
    textStyle: TextStyle(
     color: AppColors.secondaryText,
     fontWeight: FontWeight.normal, 
     fontSize: 20.sp)
    );
  static TextStyle pinText(constant) => GoogleFonts.epilogue(
    textStyle: TextStyle(
     color: AppColors.secondaryText,
     fontWeight: FontWeight.w600, 
     fontSize: 20.sp,
     decoration:TextDecoration.none
    ));
  static TextStyle nearByCardText(constant) => GoogleFonts.roboto(
    textStyle: TextStyle(
     color: AppColors.primarybuttonText,
     fontWeight: FontWeight.normal, 
     fontSize: 9.sp,
     decoration:TextDecoration.none
    ));
  static TextStyle connectTitle(constant) => GoogleFonts.roboto(
    textStyle: TextStyle(
     color: Color(0xFF023E5C),
     fontWeight: FontWeight.bold, 
     fontSize: 18.sp,
     decoration:TextDecoration.none
    ));
  static TextStyle? timer(Constants constant) => GoogleFonts.roboto(
        textStyle: TextStyle(
         color: AppColors.primaryText,
         fontWeight: FontWeight.normal, 
         fontSize: 12.sp)
        );
  static TextStyle? connectionCard(Constants constant) => GoogleFonts.roboto(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: Color(0xFFFFFFFF)
  );
}