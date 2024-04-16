import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/models/app_notifications.dart';
import 'package:justeasy/models/notifiable.dart';
import 'package:justeasy/models/user.dart';
import 'package:justeasy/routes/route_controller.dart';

class LocalNotification{
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
  late final IOSInitializationSettings initializationSettingsIOS;
  final BuildContext context;
  
  LocalNotification(BuildContext this.context){
    init();
  }

  void init()async  {
    // initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettingsIOS = IOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,);
await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onSelectNotification: selectNotification);
  }

void selectNotification(String? payload) async {
  Console.log('notification payload: $payload');
    if (payload != null) {
      AppNotification notification = AppNotification.fromjson(jsonDecode(payload));
      Console.log("notficable is : ${notification.notifiable_type}");
      if(notification.notifiable_type == Notifiable.MatchNotifiable){
        AppRouteController.gotoConnectionRequestScreen(context,User.fromJson(notification.data['second_profile']),notification.data['match_id'],notification.data['second']);
      }else if(notification.notifiable_type == Notifiable.ConnectMatchNotifiable){
        AppRouteController.gotoConnectScreen(context,User.fromJson(notification.data['second_profile']),notification.data['match'],notification.data['second']);
      }else{
        AppRouteController.gotoNotificationScreen(context);
      }
      Console.log('notification payload: $payload');
    }
    Console.log("fired!!!");
}

// void onDidReceiveLocalNotification(
//     int? id, String? title, String? body, String? payload) async {
//   // display a dialog with the notification details, tap ok to go to another page
//   showDialog(
//     context: context,
//     builder: (BuildContext context) => CupertinoAlertDialog(
//       title: Text(title??""),
//       content: Text(body??""),
//       actions: [
//         CupertinoDialogAction(
//           isDefaultAction: true,
//           child: Text('Ok'),
//           onPressed: () async {
//             // Navigator.of(context, rootNavigator: true).pop();
//             Console.log("Fired on IOS!!!");
//           },
//         )
//       ],
//     ),
//   );
// }

void showNotification({required String channel, required String channelDescription, required String channelName, required String title, required String body,String payload=""})async{
  AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('$channel', '$channelName',
        channelDescription: '$channelDescription',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
 NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
await flutterLocalNotificationsPlugin.show(
    0, '$title', '$body', platformChannelSpecifics,
    payload: payload);
}

}