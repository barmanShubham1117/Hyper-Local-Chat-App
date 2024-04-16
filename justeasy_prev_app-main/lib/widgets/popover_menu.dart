import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/constants.dart';

class PopOverMenu{
  static menu({required BuildContext context,required Constants constant, required Function onClick, required IconData icon, required String text}){
    return InkWell(
          onTap: (){
            onClick(context);
          },
          child: Container(
            padding: EdgeInsets.only(left: constant.screenWidth * 0.08),
            // width: constant.screenWidth * 0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  icon,
                  color: AppColors.primaryText,
                ),
                Text(
                  "     $text",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.epilogue(
                    color:AppColors.primaryText,
                    fontSize: 16.w,
                    fontWeight: FontWeight.normal
                  ),
                ),
              ],
            ),
          ),
        );
  }
}