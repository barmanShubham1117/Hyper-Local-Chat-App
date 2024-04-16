import 'package:flutter/widgets.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/models/chat_data.dart';
import 'package:justeasy/models/user.dart';

class ChatMessage{

  static const RECEIVED = 0;
  static const SENT = 1;

  static Widget renderMessage({required Constants constant, required ChatData data}){
    User user = DataManager.user;
    List<String> sentAt = data.sentAt.split("T")[1].split(":");
    return Container(
      width: constant.screenWidth,
      alignment: data.sentBy == user.id ? Alignment.centerLeft : Alignment.centerRight,
      margin: EdgeInsets.only(bottom: 5, right: data.sentBy == user.id ? 50 : 10,left:data.sentBy == user.id ? 10 : 50,top:5),
      // padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: data.sentBy == user.id ? CrossAxisAlignment.start :CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: data.sentBy == user.id ? AppColors.primaryBG.withOpacity(0.2) : AppColors.placeholderColor.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(data.sentBy == user.id ? 0 : 20),
                topRight: const Radius.circular(20),
                topLeft: const Radius.circular(20),
                bottomRight: Radius.circular(data.sentBy == user.id ? 20 : 0),
              ),
            ),
            child: Text(
              data.data
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