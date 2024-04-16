import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:justeasy/controllers/nearby_controller.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/models/user.dart';
import 'package:location/location.dart';

class BackgroundEx{
  static Future<void> init(Function onStart) async {
    Console.log("bg here..");
    // final service = FlutterBackgroundService.initialize(onStart, autoStart: true, foreground: false);
    final service = FlutterBackgroundService();
    Console.log("bg started 1..");
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: onIosBackground,
      ),
    );
    Console.log("bg started returned..");
  }

  static void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  Console.log('FLUTTER BACKGROUND FETCH');
}

  void onStart() {
    WidgetsFlutterBinding.ensureInitialized();
    final service = FlutterBackgroundService();
    Console.log("bg started..");
    service.onDataReceived.listen((event) {
      if (event!["action"] == "setAsForeground") {
        service.setForegroundMode(true);
        return;
      }
  
      if (event["action"] == "setAsBackground") {
        service.setForegroundMode(false);
      }
  
      if (event["action"] == "stopService") {
        service.stopBackgroundService();
      }
    });
     // bring to foreground
    service.setForegroundMode(true);
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!(await service.isServiceRunning())) timer.cancel();
      service.setNotificationInfo(
        title: "My App Service",
        content: "Updated at ${DateTime.now()}",
      );
  
      // test using external plugin
      // final deviceInfo = DeviceInFo();
      // String? device;
      // if (Platform.isAndroid) {
      //   final androidInfo = await deviceInfo.androidInfo;
      //   device = androidInfo.model;
      // }
  
      // if (Platform.isIOS) {
      //   final iosInfo = await deviceInfo.iosInfo;
      //   device = iosInfo.model;
      // }
  Console.log("up and running...");
    // NearByController.updateLocation(DataManager.user, Location());
    // NearByController.getNearbyUsersBG().then((result){
    //   List<User> list = [];
    //   bool au = result.data['unauthenticated'] ?? false;
    //   if(au){
    //     // service.stopBackgroundService();
    //   }else{
    //     list = (result.data['users'] as List).map<User>((json)=>User.fromJson(json)).toList();
    //     service.sendData(
    //       {
    //         "users":list,
    //       },
    //     );
    //   }
    // });
    });
  }
}