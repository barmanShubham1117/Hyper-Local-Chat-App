import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/message_parser.dart';
import 'package:justeasy/models/api_response.dart';

class Notify{
  final BuildContext context;
  final dynamic message ;
  final String type;
  final int messageType;
  final Color _errorColor = AppColors.error;
  final Color _successColor = AppColors.success;
  final Color _infoColor = AppColors.info;
  static const int APINOTIFICATION = 1;
  static const int TEXTNOTIFICATION = 0;

  Notify({
    required this.context,
    required this.type,
    required this.messageType,
    required this.message,
  }){
    String showMessage = '';
    if(messageType == 1){
      MessageParser parsedMessage = MessageParser(message);
      showMessage = parsedMessage.message[0];
    }else{
      showMessage = message ;
    }
    show(context, showMessage, type);
  }
  // void api(context, ApiResponse response){
  //   Constants constant = Constants(context);
  //   MessageParser parsedMessage = MessageParser(response.message);
  //   List<String> messages = parsedMessage.message;
  //   SnackBar snackBar = SnackBar(
  //     content:Text(
  //         messages[0],
  //         style: TextStyle(color: Colors.white),
  //       ),
  //     backgroundColor: getMessageColor('error'),
  //     behavior: SnackBarBehavior.floating
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }  
  void show(context, String message, String type){
    Constants constant = Constants(context);
    SnackBar snackBar = SnackBar(
      content:Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      backgroundColor: getMessageColor(type),
      behavior: SnackBarBehavior.floating
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }  

  Color getMessageColor(String type){
    Color color = _errorColor;
    switch(type){
      case 'success': color = _successColor;
      break;
      case 'info': color = _infoColor;
      break;
      default: color = _errorColor;
    }
    return color;
  }
}