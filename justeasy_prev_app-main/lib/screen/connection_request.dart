import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:justeasy/config/app_config.dart';
import 'package:justeasy/controllers/match_controller.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/helpers/text_style.dart';
import 'package:justeasy/models/user.dart';

class ConnectionRequestScreen extends StatelessWidget {
  ConnectionRequestScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);
    Constants constant  = Constants(context); 
    User user = constant.passedData["user"];
    // User user = DataManager.user;
    String match = constant.passedData["match"];
    String second = constant.passedData["second"];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.secondaryBG,
          foregroundColor: AppColors.secondaryText,
          title: Text(
              'Connection Request',
              style: constant.textTheme.headline3?.copyWith(
                fontSize: 24.sp,
              ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Container(
                  width: constant.screenWidth * 0.8,
                  height: constant.screenHeight * 0.6,
                  decoration: BoxDecoration(
                    color: AppColors.mutedColor,
                    image:  DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter:const ColorFilter.mode(Color(0x50000000), BlendMode.colorBurn),
                      image: NetworkImage('${AppConfig.mainUrl}/${user.image}'),
                    ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10,top:10),
                        // decoration:BoxDecoration(
                        //   boxShadow: [
                        //     BoxShadow(
                        //       color: Colors.black.withOpacity(15),
                        //       blurRadius: 15,
                        //       spreadRadius: 0,
                        //       offset: Offset(10,10)
                        //     ),
                        //   ],
                        // ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   width: constant.screenWidth * 0.15,
                            //   padding: EdgeInsets.all(3),
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(10),
                            //     color: Color(0x30FFFFFF)
                            //   ),
                            //   child: Row(
                            //     children: [
                            //       Icon(Icons.location_on_outlined, color:AppColors.secondaryBG),
                            //       Text(
                            //         '1 m',
                            //         style: AppTextStyle.connectionCard(constant)?.copyWith(
                            //           fontWeight: FontWeight.bold
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(top:2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0x30FFFFFF)
                              ),
                              child: Text(
                                user.location,
                                style: AppTextStyle.connectionCard(constant)?.copyWith(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: constant.screenWidth,
                        height: constant.screenHeight * 0.12,
                        padding: const EdgeInsets.only(left: 20, top:10),
                        decoration: const BoxDecoration(
                          color: Color(0x90000000),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.nickName,
                              style: AppTextStyle.connectionCard(constant)?.copyWith(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            // Text(
                            //   "Writer and Director",
                            //   style: AppTextStyle.connectionCard(constant),
                            // ),
                            SizedBox(
                              height:constant.screenHeight * 0.01,
                            ),
                            Text(
                              user.status,
                              style: AppTextStyle.connectionCard(constant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      Console.log('clicked');
                      MatchController.updateMatch(context, second, "0");
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondaryBG,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFb1b1b1),
                            spreadRadius: 1,
                            offset: Offset(1,7),
                            blurRadius: 5,
                          ),
                          // BoxShadow(
                          //   color: Color(0xFFb1b1b1),
                          //   spreadRadius: 2,
                          //   offset: Offset(-7,-7),
                          //   blurRadius: 10,
                          // ),
                        ],
                      ),
                      child: Image.asset("assets/images/icons/close-small.png"),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      MatchController.updateMatch(context, second, "1");
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [AppColors.buttonColor.withOpacity(0.2), AppColors.iconColor], begin: Alignment.topRight,end: Alignment.bottomRight),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.primaryBG,
                            spreadRadius: 2,
                            offset: Offset(1,7),
                            blurRadius: 10,
                          ),
                          // BoxShadow(
                          //   color: AppColors.mutedColor,
                          //   spreadRadius: 2,
                          //   offset: Offset(-7,-7),
                          //   blurRadius: 10,
                          // ),
                        ],
                      ),
                      child: Image.asset("assets/images/icons/connect_white.png"),
                    ),
                  ),
                ],
              ),
            ],
        ),
      ),
    );
  }
}