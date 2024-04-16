import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justeasy/controllers/asset_controller.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/helpers/notify.dart';
import 'package:justeasy/models/social.dart';
import 'package:justeasy/models/user.dart';

class ChatData{
  final String data, readAt, room, sentBy, id, sentAt;
  final int type ;

  ChatData({required this.type, required this.data, required this.sentAt, required this.readAt, required this.room, required this.sentBy, required this.id});

  static ChatData fromJson(json){
    return ChatData(
      type: int.parse(json["type"]), 
      data: json["data"]??'',
      readAt: json["read_at"]??'',
      sentAt : json["createdAt"]??'',
      room:json["room_id"]??'',
      sentBy: json["sent_by"]??'',
      id: json["_id"]??'',
    );
  }
  

  Widget renderMessage(BuildContext context, Constants constant){
    switch(type){
      case 0: return renderNormal(context,constant);
      case 1: return renderSocial(context,constant);
      case 2: return renderMeetUp(context,constant);
      default: return renderNormal(context,constant);
    }
  }


  Widget renderNormal(BuildContext context, Constants constant){
    ScreenUtil.setContext(context);
    User user = DataManager.user;
    DateTime sentAt = DateTime.parse(this.sentAt).toLocal();
    return Container(
      width: constant.screenWidth,
      alignment: sentBy == user.id ? Alignment.centerLeft : Alignment.centerRight,
      margin: EdgeInsets.only(bottom: 5, right: sentBy == user.id ? 50 : 10,left:sentBy == user.id ? 10 : 50,top:5),
      // padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: sentBy == user.id ? CrossAxisAlignment.start :CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: sentBy == user.id ? AppColors.primaryBG.withOpacity(0.1) : AppColors.placeholderColor.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(sentBy == user.id ? 0 : 20),
                topRight: const Radius.circular(20),
                topLeft: const Radius.circular(20),
                bottomRight: Radius.circular(sentBy == user.id ? 20 : 0),
              ),
            ),
            child: Text(
              data,
              style:GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black
              ),
            ),
          ),
          Text(
            "${sentAt.hour}:${sentAt.minute.toString().length  == 1 ? "0" : ""}${sentAt.minute}",
          ),
        ],
      ),
    );
  }
  Widget renderSocial(BuildContext context, Constants constant){
    User user = DataManager.user;
    List<String> sentAt = this.sentAt.split("T")[1].split(":");
    Social social = Social.fromJson(jsonDecode(data));
    return GestureDetector(
      onTap: (){
        Clipboard.setData(ClipboardData(text:social.value));
        Notify(
          context: context,
          message: "Social detail will be copied on your clipboard.",
          messageType: Notify.TEXTNOTIFICATION,
          type: 'info'
        );
      },
      child: Container(
        width: constant.screenWidth,
        alignment: sentBy == user.id ? Alignment.centerLeft : Alignment.centerRight,
        margin: EdgeInsets.only(bottom: 5, right: sentBy == user.id ? 50 : 10,left:sentBy == user.id ? 10 : 50,top:5),
        // padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: sentBy == user.id ? CrossAxisAlignment.start :CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: sentBy == user.id ? AppColors.primaryBG.withOpacity(0.2) : AppColors.placeholderColor.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(sentBy == user.id ? 0 : 20),
                  topRight: const Radius.circular(20),
                  topLeft: const Radius.circular(20),
                  bottomRight: Radius.circular(sentBy == user.id ? 20 : 0),
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Image.asset(
                      AssetController.socialList[social.type],
                      height:constant.screenHeight * 0.03,
                    ),
                    SizedBox(
                      width: constant.screenWidth * 0.03,
                    ),
                    Text(
                      social.name,
                      style:GoogleFonts.epilogue(
                        color:Color(0xFF555555),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              "${sentAt[0]}:${sentAt[1]}"
            ),
          ],
        ),
      ),
    );
  }
  Widget renderMeetUp(BuildContext context, Constants constant){
    User user = DataManager.user;
    List<String> sentAt = this.sentAt.split("T")[1].split(":");
    return Container(
      width: constant.screenWidth,
      alignment: sentBy == user.id ? Alignment.centerLeft : Alignment.centerRight,
      margin: EdgeInsets.only(bottom: 5, right: sentBy == user.id ? 50 : 10,left:sentBy == user.id ? 10 : 50,top:5),
      // padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: sentBy == user.id ? CrossAxisAlignment.start :CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: sentBy == user.id ? AppColors.primaryBG.withOpacity(0.2) : AppColors.placeholderColor.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(sentBy == user.id ? 0 : 20),
                topRight: const Radius.circular(20),
                topLeft: const Radius.circular(20),
                bottomRight: Radius.circular(sentBy == user.id ? 20 : 0),
              ),
            ),
            child: Center(
              child:Text(
                "Lets meet up!",
                style:GoogleFonts.allura(
                  color:AppColors.secondaryText,
                  fontSize: 36,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Text(
            "${sentAt[0]}:${sentAt[1]}"
          ),
        ],
      ),
    );
  }

}
