import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justeasy/config/app_config.dart';
import 'package:justeasy/controllers/asset_controller.dart';
import 'package:justeasy/controllers/match_controller.dart';
import 'package:justeasy/controllers/nearby_controller.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/text_style.dart';
import 'package:justeasy/models/api_response.dart';
import 'package:justeasy/models/user.dart';
import 'package:justeasy/routes/route_controller.dart';
import 'package:justeasy/screen/nearby.dart';
import 'package:justeasy/widgets/lines.dart';
import 'package:shimmer/shimmer.dart';
import 'package:star_menu/star_menu.dart';

class UserCards{
  static nearUserCard(BuildContext context, {User? user, bool dummy = false, bool gps=false, required List<dynamic> block, bool isBlocked = false}){
    ScreenUtil.setContext(context);
    Constants constant = Constants(context);
    Console.log("${AppConfig.mainUrl}/${user?.image}");
    ValueNotifier<bool> notifier = ValueNotifier<bool>(isBlocked);
    return dummy ? SizedBox(
      width: constant.screenWidth * 0.35,
      height: constant.screenWidth * 0.3,
      child:Shimmer.fromColors(
                baseColor: Colors.grey[300]??Colors.grey,
                highlightColor: Colors.grey[100]??Colors.grey,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    // borderRadius: gps ? BorderRadius.only(
                    //   bottomLeft: Radius.circular(20),
                    // ) :BorderRadius.only(
                    //   topLeft: Radius.circular(2),
                    //   topRight: Radius.circular(2)
                    // ),
                  ),
                ),
            ),
    ) : SizedBox(
          width: constant.screenWidth * 0.4,
          height: 60.h,
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      borderRadius: gps ?BorderRadius.only(
                         bottomLeft: Radius.circular(20.w),
                        ) : BorderRadius.only(
                      topLeft: Radius.circular(25.w),
                      topRight: Radius.circular(25.w)
                    ),
                    color: Colors.grey,
                    image: DecorationImage(
                      image: NetworkImage('${AppConfig.mainUrl}/${user?.image}'),
                      fit: BoxFit.fill
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment:Alignment.centerRight,
                        margin:const  EdgeInsets.only(
                          top: 10,
                          right:10,
                        ),
                        
                        child:Icon(
                                Icons.more_vert,
                                color:AppColors.secondaryBG.withOpacity(0.6),
                              ),
                        ).addStarMenu(context, [
                          StarMenu(
                            child: Container(
                              width: constant.screenWidth * 0.3,
                              height: constant.screenHeight * 0.1,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryBG,
                                borderRadius:BorderRadius.circular(constant.screenWidth * 0.05)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap:(){
                                      MatchController.creatMatch(context, user?.id??"0");
                                    },
                                    child:Text("Connect",
                                      style:GoogleFonts.ptSans(
                                        fontSize: 17,
                                        fontWeight:FontWeight.normal,
                                        color: AppColors.primaryText 
                                      ),
                                    ),
                                  ),
                                  Line.horizontalLine(Size(constant.screenWidth * 0.3,constant.screenWidth * 0.005),AppColors.placeholderColor.withOpacity(0.5)),
                                  ValueListenableBuilder(valueListenable: notifier, builder: (context,value,child){
                                    return InkWell(
                                      onTap:()async{
                                        if(!notifier.value){
                                          ApiResponse result = await NearByController.blockUser(context, user?.id??"0");
                                          if(result.success)isBlocked = true;
                                        }else{
                                          ApiResponse result = await NearByController.unBlockUser(context, user?.id??"0");
                                          if(result.success)isBlocked = false;
                                        } 
                                        block = await NearByController.getBlockUser(context);
                                        // Navigator.pop(context);
                                        notifier.value = isBlocked;
                                      },
                                      child:Text(
                                        isBlocked ? "unblock" : "Block",
                                        style:GoogleFonts.ptSans(
                                          fontSize: 17,
                                          fontWeight:FontWeight.normal,
                                          color: AppColors.primaryText 
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ], StarMenuParameters(
                          onItemTapped: (index,controller){
                            controller.closeMenu();
                          }
                        )),
                       InkWell(
                              onTap: (){
                                MatchController.creatMatch(context, user?.id??"0");
                              },
                              child: Container(
                        width: constant.screenWidth * 0.4,
                        height: constant.screenWidth * 0.08,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            topRight: Radius.circular(25),
                          )
                        ),
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceAround,
                          children: [
                            // SizedBox(
                            //   width: constant.screenWidth * 0.05,
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  // width:constant.screenWidth * 0.2,
                                  child:Text(
                                    user?.userName??'No name',
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                       color: AppColors.primarybuttonText,
                                       fontWeight: FontWeight.normal, 
                                       fontSize: 9.sp,
                                       decoration:TextDecoration.none
                                      )),
                                  ),
                                ),
                                SizedBox(
                                  width:50.w,
                                  child: Text(
                                    user?.status??'No status',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.nearByCardText(constant).copyWith(
                                      fontSize: 8.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                           Image.asset(
                                'assets/images/icons/shake.png',
                                color: AppColors.primarybuttonText,
                                height: constant.screenWidth * 0.03,
                                width: constant.screenWidth * 0.03,
                              )
                            
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
                ValueListenableBuilder(valueListenable: notifier, builder: (context, value, child){
                  return 
                Visibility(
                    visible: notifier.value,
                    child: 
                    // Positioned(
                    //   right: 10,
                    //   top: 10,
                    //   child:
                Center(
                  child: Text(
                    'BLOCKED',
                    style: GoogleFonts.roboto(
                      fontSize:20.sp,
                      fontWeight: FontWeight.normal,
                      color: AppColors.primaryText
                    ),
                  ),
                ),
                    );
                  // )
                }),
              ],
            ),
        );
  }
}