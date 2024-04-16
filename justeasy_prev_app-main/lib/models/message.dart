import 'package:flutter/widgets.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/models/user.dart';

class MessageData{
  final String message;
  final String type;
  final String time;
  final String id;

  MessageData({required this.time, required this.message, required this.type, required this.id});

  static MessageData fromJson(jsonData){
    return MessageData(
      message: jsonData['message']??'',
      type: "${jsonData['type']}",
      time: jsonData['time']??'',
      id:jsonData["_id"]??'',
    ); 
  }
}