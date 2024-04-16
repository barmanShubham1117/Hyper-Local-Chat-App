import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:justeasy/controllers/match_controller.dart';
import 'package:justeasy/controllers/nearby_controller.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/models/notifiable.dart';
import 'package:justeasy/models/user.dart';
import 'package:justeasy/routes/route_controller.dart';

class AppNotification{
  static const int MatchNotifiable = 1;
  static const int ConnectMatchNotifiable = 1;

  final int type, notifiable_type;
  final Map<String,dynamic> data;
  final String readAt,id,message,dateTime;

  AppNotification({required this.dateTime,required this.type, required this.data, required this.readAt, required this.message, required this.id, required this.notifiable_type});

  static fromjson(json){
    return AppNotification(
      dateTime: json['createdAt']??'',
      type : convertType(json['type']??0),
      data : jsonDecode(json['data'])??{},
      notifiable_type: int.parse(json['notifiable_type']??'0'),
      message: json['message'],
      id: json["_id"],
      readAt : json['read_at']??'',
    );
  }

  static int convertType(type){
    switch(type){
      case 'MatchList' : return MatchNotifiable ;
      default : return MatchNotifiable ;

    }
  }

  static int resolveNotifiable(type,notifiable){
    if(type == MatchNotifiable && notifiable == ConnectMatchNotifiable) return ConnectMatchNotifiable ;
    return 0;
  }

  static Widget notificationWidget(BuildContext context,Constants constant,AppNotification notification){
    ScreenUtil.setContext(context);
    DateTime localTime = DateTime.parse(notification.dateTime).toLocal();
    return Dismissible(
      key: GlobalKey(),
      onDismissed: (d){
        MatchController.readNotification(context, notification.id);
      },
      child: InkWell(
      onTap: ()async{
        // Console.log(notification.notifiable_type);
        MatchController.readNotification(context, notification.id);
        if(notification.notifiable_type != AppNotification.ConnectMatchNotifiable){
          // Console.log(notification.data['second'],p:true);
          User user = User.fromJson(notification.data['second_profile']);
          AppRouteController.gotoConnectionRequestScreen(context,user,notification.data['match_id'],notification.data['second']);
        }else if(notification.notifiable_type == Notifiable.ConnectMatchNotifiable){
          User user = User.fromJson(notification.data['second_profile']);
          AppRouteController.gotoConnectScreen(context,user,notification.data['match'],notification.data['second']);
        }
      },
      child: Container(
        height: 70.h,
        width: constant.screenWidth,
        // color: AppColors.primaryBG,
        decoration: BoxDecoration(
          color: AppColors.secondaryBG,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.mutedColor,
              offset: Offset(0,0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ]
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: constant.textTheme.bodyText1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${localTime.day}-${localTime.month}-${localTime.year}",
                  style: constant.textTheme.bodyText2?.copyWith(
                    fontSize: 12.w,
                  ),
                ),
                Text(
                  "${localTime.hour}:${localTime.minute.toString().length == 1 ? "0" : ""}${localTime.minute}",
                  style: constant.textTheme.bodyText2?.copyWith(
                    fontSize: 12.w,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
    );
  }

// static void 

}