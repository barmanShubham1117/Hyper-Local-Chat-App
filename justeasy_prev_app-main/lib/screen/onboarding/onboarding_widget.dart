import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/constants.dart';

class OnBoardingWidget extends StatelessWidget {
  AssetImage image;
  String text;
  Constants constant;

  OnBoardingWidget({ Key? key, required this.constant, required this.image, required this.text }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // padding: EdgeInsets.only(left:constant.screenWidth * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.only(top:10),
              width: constant.screenWidth * 0.75,
              child: Text(
                text,
                style: GoogleFonts.workSans(
                textStyle: TextStyle(
                 color: AppColors.primaryText,
                 fontWeight: FontWeight.w700, 
                 letterSpacing: -1,
                 fontSize: 38.sp)
                ),
              ),
            ),
            Container(
              width: constant.screenWidth * 0.85,
              child: Image(
                image: image,
              ),
            ),
          ],
        ),
      ),
    );
  }
}