import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/constants.dart';

class Line{
  static horizontalLine(Size size, Color color){
    return Container(
      color: color,
      width: size.width,
      height: size.height,
    );
  }

  static horizonalLineHeading(Constants constant, Color color, String text){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Line.horizontalLine(Size(constant.screenWidth * 0.3, constant.screenHeight * 0.0015), color),
        Text(
          text,
          style: GoogleFonts.roboto(
            color:Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400
          )
        ),
        Line.horizontalLine(Size(constant.screenWidth * 0.3, constant.screenHeight * 0.0015), color),
      ],
    );
  }
}