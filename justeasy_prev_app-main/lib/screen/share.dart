import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justeasy/controllers/asset_controller.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/widgets/buttons.dart';
import 'package:flutter_share/flutter_share.dart';

class ShareScreen extends StatelessWidget {
  ShareScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);
    final Constants constant = Constants(context);
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(
          elevation: 0,
          backgroundColor: AppColors.primaryBG,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
        ),
        backgroundColor: AppColors.primaryBG,
        body:SingleChildScrollView(
          child: Container(
            width: constant.screenWidth,
            height: constant.screenHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Share',
                  style: GoogleFonts.allura(
                    fontSize: 48,
                    color: Colors.black
                  ),
                ),
                SizedBox(
                  height: constant.screenHeight * 0.03,
                ),
                Image(
                  image:AssetController.fourthOnBoarding,
                ),
                SizedBox(
                  height: constant.screenHeight * 0.03,
                ),
                Text(
                  'Share this Application',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
                
                Center(
                  child: Text(
                    'https://play.google.com/apps/internaltest/4701015563174276900',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black
                    ),
                  ),
                ),
                SizedBox(
                  height: constant.screenHeight * 0.03,
                ),
                Buttons.largeButton(context, constant, "Share", (context)async{
                  await FlutterShare.share(
                    title: 'Just Easy',
                    text: 'Check this app and connect with professionals near you. https://play.google.com/apps/internaltest/4701015563174276900',
                    linkUrl: 'https://play.google.com/apps/internaltest/4701015563174276900',
                    chooserTitle: 'Share Just easy'
                  );
                }, multiplyer:0.03),
                 SizedBox(
                  height: constant.screenHeight * 0.1,
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}