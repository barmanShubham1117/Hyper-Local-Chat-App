import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/widgets/buttons.dart';

class SettingScreen extends StatelessWidget {
   SettingScreen({ Key? key }) : super(key: key);


final ValueNotifier<bool> enterNotifier = ValueNotifier(false);
final ValueNotifier<bool> notificationNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);
    final Constants constant = Constants(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.h),
          child: Container(
            padding: EdgeInsets.only(left: constant.screenWidth * 0.05),
            color: AppColors.primaryBG,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Buttons.backButton(context),
                  Container(
                    padding: EdgeInsets.only(left:10,bottom: 5),
                    child: Text(
                      'Settings',
                      style: GoogleFonts.epilogue(
                      textStyle: TextStyle(
                        color: Color(0xFF10394E),
                        fontWeight: FontWeight.w600, 
                        fontSize: 25.sp)
                       ),
                    ),
                  ),
                ],
            ),
          ),
        ),
        body:SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top:constant.screenHeight * 0.02),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.start,
              children: [
                settingOptions(context, constant, 'Enter is send', 'Enter key will send your message while chatting',enterNotifier),
                settingOptions(context, constant, 'Notification', 'By Default',notificationNotifier),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:[
                    Container(
                      width: constant.screenWidth * 0.4,
                      height:constant.screenWidth * 0.4,
                      padding: EdgeInsets.only(left:10),
                      decoration: BoxDecoration(
                        color: AppColors.buttonColor,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: constant.screenWidth * 0.15,
                            height:constant.screenWidth * 0.15,
                            decoration: BoxDecoration(
                              color: AppColors.primaryBG,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(
                              child: Icon(
                                Icons.description_outlined,
                                color: AppColors.secondaryBG,
                                size: constant.screenWidth * 0.1,
                              ),
                            ),
                          ),
                          Text(
                            'Instructions',
                            style: GoogleFonts.epilogue(
                              fontWeight:FontWeight.w400,
                              color: Colors.white,
                              fontSize: 11.sp,
                            ),
                          ),
                          Text(
                            'Understanable instructions',
                            style: GoogleFonts.epilogue(
                              fontWeight:FontWeight.normal,
                              color: Color(0xFF98C1D9),
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: constant.screenWidth * 0.4,
                      height:constant.screenWidth * 0.4,
                      padding: EdgeInsets.only(left:10),
                      decoration: BoxDecoration(
                        color: AppColors.buttonColor,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: constant.screenWidth * 0.15,
                            height:constant.screenWidth * 0.15,
                            decoration: BoxDecoration(
                              color: AppColors.primaryBG,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/images/chat.png",
                                width: constant.screenWidth * 0.1,
                              ),
                            ),
                          ),
                          Text(
                            'You need any help?',
                            style: GoogleFonts.epilogue(
                              fontWeight:FontWeight.w400,
                              color: Colors.white,
                              fontSize: 11.sp,
                            ),
                          ),
                          Text(
                            'contact \nsupport',
                            style: GoogleFonts.epilogue(
                              fontWeight:FontWeight.normal,
                              color: Color(0xFF98C1D9),
                              fontSize: 11.sp,
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
        )
      ),
    );
  }

  Widget settingOptions(BuildContext context, Constants constant, String title, String description, ValueNotifier notifier){
    return Container(
      height: constant.screenHeight * 0.1,
      margin: EdgeInsets.all(constant.screenHeight * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: constant.screenWidth * 0.7,
            child: RichText(
              text: TextSpan(
                text: "$title\n",
                children: [
                  TextSpan(
                    text:description,
                    style: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.normal,
                      color:AppColors.placeholderColor,
                    ),
                  ),
                ],
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.normal,
                  color:AppColors.primaryText,
                ),
              ),
            ),
          ),

          ValueListenableBuilder(
            valueListenable: notifier,
            builder: (context, value, child){
              return Switch(
                value: notifier.value, 
                activeColor: Colors.black,
                onChanged: (v){
                  notifier.value = v;
                }
              );
            },
          )
        ],
      ),
    );
  }

}