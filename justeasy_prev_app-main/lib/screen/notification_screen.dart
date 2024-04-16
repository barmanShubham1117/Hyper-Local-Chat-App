import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justeasy/controllers/match_controller.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/models/app_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';


class NotificationScreen extends StatelessWidget {
   NotificationScreen({ Key? key }) : super(key: key);
  List<AppNotification> notifications = [];
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);
    Constants constant  = Constants(context); 
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.secondaryBG,
        appBar: AppBar(
          backgroundColor: AppColors.secondaryBG,
          foregroundColor: AppColors.secondaryText,
          title: Text(
            'Notifications',
            style: GoogleFonts.epilogue(
              fontSize:20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: FutureBuilder(
          future: MatchController.getNotifications(context),
          builder: (context, snapshot){
            // return snapshot.hasData ? Container()
            // : Container();
            if(snapshot.connectionState == ConnectionState.done){
              notifications = snapshot.hasData ? snapshot.data as List<AppNotification> : [];
            }
            return snapshot.connectionState == ConnectionState.done ? Container(
              color:AppColors.primaryBG.withOpacity(0.5),
              height: constant.screenHeight,
              child: SingleChildScrollView(
                child: notifications.length > 0 ? Column(
                  children: List.generate(notifications.length, (index){
                    return AppNotification.notificationWidget(context, constant, notifications[(notifications.length-1)-index]);
                }),
                ):Container(
                  height: constant.screenHeight * 0.8,
                  alignment: Alignment.center,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/anime/empty_noti.json',
                      ),
                      Text(
                        'No notifications.',
                        style: GoogleFonts.epilogue(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ) : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) => Container(
              width: constant.screenWidth,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.mutedColor
                  ),
                ),
              ),
              child:Shimmer.fromColors(
                  baseColor: Colors.grey[300]??Colors.grey,
                  highlightColor: Colors.grey[100]??Colors.grey,
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: constant.screenWidth,
                        height: 20,
                        color: Colors.grey,
                        margin: const EdgeInsets.all(10),
                      ),
                      Container(
                        width: constant.screenWidth * 0.5,
                        height: 20,
                        color: Colors.grey,
                        margin: const EdgeInsets.all(10),
                      )
                    ],
                  ),
              ),
            )),
            );
          },
        ),
      ),
    );
  }

}

// class NotificationScreen extends StatefulWidget {
//   NotificationScreen({ Key? key }) : super(key: key);

//   @override
//   _NotificationScreenState createState() => _NotificationScreenState();
// }

// List<AppNotification> notifications = [];

// class _NotificationScreenState extends State<NotificationScreen> {
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.setContext(context);
//     Constants constant  = Constants(context); 
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColors.secondaryBG,
//         appBar: AppBar(
//           backgroundColor: AppColors.secondaryBG,
//           foregroundColor: AppColors.secondaryText,
//           title: Text(
//             'Notifications',
//             style: GoogleFonts.epilogue(
//               fontSize:20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         body: FutureBuilder(
//           future: MatchController.getNotifications(context),
//           builder: (context, snapshot){
//             // return snapshot.hasData ? Container()
//             // : Container();
//             if(snapshot.connectionState == ConnectionState.done){
//               notifications = snapshot.hasData ? snapshot.data as List<AppNotification> : [];
//             }
//             return snapshot.connectionState == ConnectionState.done ? Container(
//               color:AppColors.primaryBG.withOpacity(0.5),
//               height: constant.screenHeight,
//               child: SingleChildScrollView(
//                 child: notifications.length > 0 ? Column(
//                   children: List.generate(notifications.length, (index){
//                     return AppNotification.notificationWidget(context, constant, notifications[index]);
//                   }),
//                 ):Container(
//                   height: constant.screenHeight * 0.8,
//                   alignment: Alignment.center,
//                   child:Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Lottie.asset(
//                         'assets/anime/empty_noti.json',
//                       ),
//                       Text(
//                         'No notifications.',
//                         style: GoogleFonts.epilogue(
//                           fontSize: 20.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ) : Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: List.generate(5, (index) => Container(
//               width: constant.screenWidth,
//               margin: const EdgeInsets.only(bottom: 10),
//               decoration: const BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(
//                     color: AppColors.mutedColor
//                   ),
//                 ),
//               ),
//               child:Shimmer.fromColors(
//                   baseColor: Colors.grey[300]??Colors.grey,
//                   highlightColor: Colors.grey[100]??Colors.grey,
//                   child: Column(
//                     crossAxisAlignment:CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: constant.screenWidth,
//                         height: 20,
//                         color: Colors.grey,
//                         margin: const EdgeInsets.all(10),
//                       ),
//                       Container(
//                         width: constant.screenWidth * 0.5,
//                         height: 20,
//                         color: Colors.grey,
//                         margin: const EdgeInsets.all(10),
//                       )
//                     ],
//                   ),
//               ),
//             )),
//             );
//           },
//         ),
//       ),
//     );
//   }

// }