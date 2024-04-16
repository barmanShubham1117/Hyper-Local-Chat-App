import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justeasy/config/app_config.dart';
import 'package:justeasy/controllers/asset_controller.dart';
import 'package:justeasy/controllers/chat_controller.dart';
import 'package:justeasy/controllers/profile_controller.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/helpers/notify.dart';
import 'package:justeasy/helpers/text_style.dart';
import 'package:justeasy/models/social.dart';
import 'package:justeasy/models/user.dart';
import 'package:justeasy/routes/route_controller.dart';
import 'dart:math' as math;

import 'package:justeasy/widgets/buttons.dart';

class ConnectScreen extends StatefulWidget {
  ConnectScreen({ Key? key }) : super(key: key);

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final ValueNotifier<String> tickerNotifier = ValueNotifier("5:00 min Left");

  List<Social> social = [];
  bool expired = false;

  final GlobalKey _key = GlobalKey();
  Timer? ticker;

@override
  void dispose() {
    ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);
    Constants constant = Constants(context);
    User second = constant.passedData["second"];
    User user = DataManager.user;
    Map<String,dynamic> match = constant.passedData["match"];
    String id = constant.passedData["second_id"];
    Console.log("Second image");
    Console.log("${AppConfig.mainUrl}/${second.image}");

  //timer starts
    DateTime time = DateTime.parse(match["createdAt"]);
    DateTime currentTime = DateTime.now();
    var secs = currentTime.difference(time).inSeconds;
    var sect = 300-secs;
    // tickerNotifier.value = 120-secs ;
    if(sect <= 0){
      // AppRouteController.goBack(context);

      expired = true;
      tickerNotifier.value = "Match expired.";
    }
    Console.log("loggin time : ${time.hour}");
    if(ticker != null) ticker?.cancel();
    ticker = Timer.periodic(Duration(seconds: 1), (timer) {
      if(sect - 1 != 0){
        sect-=1;
        Duration d = Duration(seconds: sect);
        tickerNotifier.value = "${d.toString().substring(2,7)}";
      }else{
        timer.cancel();
        // AppRouteController.goBack(context);
        expired = true;
        tickerNotifier.value = "Match expired.";
      };
    });
    //timer ends
    return SafeArea(
      child:Scaffold(
        key: _key,
      backgroundColor: AppColors.secondaryBG,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(constant.screenWidth * 0.15),
        child: Container(
          width:constant.screenWidth,
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(left: constant.screenWidth * 0.05,top: constant.screenHeight * 0.02),
          child: Buttons.backButton(context),
        ),
      ),
      body: WillPopScope(
        onWillPop: ()async{
          ticker!.cancel();
          return true;
        },
        child: Center(
        child : SizedBox(
          width: constant.screenWidth,
          height: constant.screenHeight,
        child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: constant.screenWidth,
                height: constant.screenHeight * 0.5,
                child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 50,
                    child:Transform.rotate(
                  angle: 10 * math.pi /180,
                  // child: Container(
                    child: Stack(
                      children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration:BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 25,
                                  spreadRadius: 0,
                                  offset: Offset(0,25),
                                  color: Colors.black.withOpacity(0.15)
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                "${AppConfig.mainUrl}/${second.image}",
                                errorBuilder: (context, error, stackTrace){
                                  Console.log(error);
                                  return Image.asset(AssetController.dummyProfile,fit: BoxFit.fill,
                                  height: constant.screenHeight * 0.3,
                                  width: constant.screenWidth * 0.4,);
                                },
                                fit: BoxFit.fill,
                                height: constant.screenHeight * 0.3,
                                width: constant.screenWidth * 0.4,
                              ),
                            ),
                          ),
                        Positioned(
                          // left: -10,
                          // top: -20,
                          child: CircleAvatar(
                            backgroundColor: AppColors.secondaryBG,
                            radius: constant.screenHeight * 0.04,
                            child: Image.asset('assets/images/icons/connect.png'),
                          ),
                        ),
                      ],
                    ),
                  )),
                  Positioned(
                    top: constant.screenHeight * 0.12,
                    left: 80.w,
                    child:Transform.rotate(
                  angle: -15 * math.pi /180,
                  // child: Container(
                    child: Stack(
                      children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration:BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 25,
                                  spreadRadius: 0,
                                  offset: Offset(0,25),
                                  color: Colors.black.withOpacity(0.15)
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                "${AppConfig.mainUrl}/${user.image}",
                                errorBuilder: (context, error, stackTrace){
                                  Console.log(error);
                                  return Image.asset(AssetController.dummyProfile,fit: BoxFit.fill,
                                  height: constant.screenHeight * 0.3,
                                  width: constant.screenWidth * 0.4,);
                                },
                                fit: BoxFit.fill,
                                height: constant.screenHeight * 0.3,
                                width: constant.screenWidth * 0.4,
                              ),
                            ),
                          ),
                        Positioned(
                          // left: -10,
                          bottom: 0,
                          child: CircleAvatar(
                            backgroundColor: AppColors.secondaryBG,
                            radius: constant.screenHeight * 0.04,
                            child: Image.asset('assets/images/icons/connect.png'),
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
              // ),,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'You both are now connected',
                    style: AppTextStyle.connectTitle(constant),
                  ),
                  SizedBox(
                    height: constant.screenHeight * 0.005,
                  ),
                  Text(
                    'Start a conversation',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.normal,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: constant.screenHeight * 0.005,
                  ),
                  Text(
                    'Connection request will remain for 5 minutes',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.normal,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: constant.screenHeight * 0.02,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ValueListenableBuilder(
                    valueListenable: tickerNotifier,
                    builder:(context, value, child){
                      ScreenUtil.setContext(context);
                      return Text(
                        "${tickerNotifier.value} ${expired ?"." : "min left"}",
                        style: AppTextStyle.timer(constant),
                      );
                    }
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20,top: 20),
                    child: Buttons.largeButton(context, constant, 'Say hello' , (context){
                      showDialog(context: context, builder: (context){
                        ScreenUtil.setContext(context);
                        return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

                          content: Container(
                            height: constant.screenHeight * 0.2,
                            width: constant.screenWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:[
                                Text(
                                  'Click continue to chat',
                                  style: AppTextStyle.connectTitle(constant),
                                ),
                                Buttons.largeButton(context, constant, 'Continue', (context){
                                  ChatController.createChat(context, match["_id"]);
                                }),
                                Buttons.largeButton(context, constant, 'Wait', AppRouteController.goBack, background: AppColors.buttonColor.withOpacity(0.1), textColor: AppColors.buttonColor),
                                ValueListenableBuilder(valueListenable: tickerNotifier, builder: (context, value, child){
                                  ScreenUtil.setContext(context);
                                  return Text(
                                    expired ? "Match Expired" :'Take action Before ${tickerNotifier.value} minutes',
                                    style: AppTextStyle.timer(constant),
                                  );
                                }),
                              ],
                            ),
                          ),
                        );
                      });
                    }, width:constant.screenWidth * 0.7, multiplyer: constant.screenWidth * 0.00012, shader: true),
                  ),
                  Buttons.largeButton(context, constant, 'Share Details', (context){
                    showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            ScreenUtil.setContext(context);
                            return Container(
                              width: constant.screenWidth,
                              height: constant.screenHeight * 0.4,
                              padding: EdgeInsets.only(top: constant.screenHeight * 0.05,bottom: constant.screenHeight * 0.02),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBG,
                                borderRadius:BorderRadius.only(
                                  topLeft: Radius.circular(constant.screenWidth * 0.1),
                                  topRight: Radius.circular(constant.screenWidth * 0.1),
                                ),
                              ),
                              child:FutureBuilder(
                                future: ProfileController.getActiveSocials(context),
                                builder: (context, snapshot){
                                  if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                    social = snapshot.data as List<Social>;
                                  }
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:constant.screenWidth,
                                        height: constant.screenHeight * 0.22,
                                        child:GridView.count(
                                          crossAxisCount: 2,
                                          padding: const EdgeInsets.all(10),
                                          crossAxisSpacing: 20,
                                          childAspectRatio: ((constant.screenWidth * 0.5)/(constant.screenHeight * 0.06)),
                                          mainAxisSpacing:12,
                                          scrollDirection: Axis.vertical,
                                          children: List.generate(social.length, (index){
                                            return InkWell(
                                              onTap: (){
                                                Console.log(social[index].toString());
                                                ChatController.createChat(context, match["_id"], social: social[index]);
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                decoration:BoxDecoration(
                                                  color: AppColors.secondaryBG,
                                                  borderRadius: BorderRadius.circular(constant.screenWidth * 0.015),
                                                ),
                                                child:Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children:[
                                                    Image.asset(
                                                      AssetController.socialList[social[index].type],
                                                      height:constant.screenHeight * 0.03,
                                                    ),
                                                    SizedBox(
                                                      width: constant.screenWidth * 0.03,
                                                    ),
                                                    Text(
                                                      social[index].name,
                                                      style:GoogleFonts.epilogue(
                                                        color:Color(0xFF555555),
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          })
                                          // ? List.generate(nearbyUsers.length, (index) => UserCards.nearUserCard(context,user: nearbyUsers[index]))
                                          // : List.generate(10, (index) => UserCards.nearUserCard(context,dummy: true))
                                        ),
                                      ),
                                      // InkWell(
                                      //   onTap: (){
                                      //     pushMessage(context, room, user, 2,"Lets meet up");
                                      //     Navigator.pop(context);
                                      //   },
                                      //   child:Container(
                                      //     width: constant.screenWidth,
                                      //     height: constant.screenHeight * 0.06,
                                      //     margin: EdgeInsets.only(left:10,right:10),
                                      //     decoration:BoxDecoration(
                                      //       color: AppColors.secondaryBG,
                                      //       borderRadius: BorderRadius.circular(constant.screenWidth * 0.015),
                                      //     ),
                                      //     child:Center(
                                      //       child:Text(
                                      //         "Lets meet up!",
                                      //         style:GoogleFonts.allura(
                                      //           color:AppColors.secondaryText,
                                      //           fontSize: 36,
                                      //           fontWeight: FontWeight.normal,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  );
                                },
                              ),
                            );
                          });
                  }, background: AppColors.buttonColor.withOpacity(0.1), textColor: AppColors.buttonColor
                  ,width:constant.screenWidth * 0.7, multiplyer: constant.screenWidth * 0.00012)
                ],
              ),
            ],
          ),
        )),
    
      )
    )
  ,
    );
  }
}