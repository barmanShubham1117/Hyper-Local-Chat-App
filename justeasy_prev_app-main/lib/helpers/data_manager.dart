
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/models/local_notification.dart';
import 'package:justeasy/models/user.dart';
import 'package:location/location.dart';
import 'package:redis/redis.dart';

class DataManager{
  bool willChange;
  dynamic value;

  DataManager({required this.willChange, required this.value});

  static const String USER_DATA = 'user_data';

  static const EMAIL = 'hnsyd@mailto.plus';

  static Map<String, RedisConnection> connections = {};
  
  static ValueNotifier<int> notificationNotifier = ValueNotifier<int>(0);

  static LocalNotification? notifyOrganizer;

  static User user = User(
    dateOfBirth: '',
    email: '',
    id:'',
    image: '',
    location: '',
    name: '',
    nickName: '',
    status: '',
    userName: '',
    user_id: '',
    distance: 0,
    points: LocationData.fromMap(
              {
                'latitude':0.0,
                'longitude':0.0,
                'altitude':0.0,
              }
            )
  );

  static String token = '';

  static Map<String,double> location = {'latitude':0,"longitude":0,'altitude':0};

  // static FlutterBackgroundService? service;

  // static initializeLocationService()async{
  //   DataManager.service = FlutterBackgroundService();
  // await service?.configure(
  //   androidConfiguration: AndroidConfiguration(
  //     // this will executed when app is in foreground or background in separated isolate
  //     onStart: (){
  //       service?.setForegroundMode(false);
  //     },

  //     // auto start service
  //     autoStart: true,
  //     isForegroundMode: false,
  //   ),
  //   iosConfiguration: IosConfiguration(
  //     // auto start service
  //     autoStart: true,

  //     // this will executed when app is in foreground in separated isolate
  //     onForeground: (){
  //       Console.log('Running in foreground.');
  //     },

  //     // you have to enable background fetch capability on xcode project
  //     onBackground: (){

  //       Timer.periodic(const Duration(seconds: 10), (timer) {
  //         Console.log('updating location');
  //         NearByController.updateLocation(DataManager.user, Location());
  //        });
  //     },
  //   ),
  // );
  // }

  static Timer? profileTimer ;

  static DataManager _instance({willChange=false, required value}) =>DataManager(value: value, willChange: willChange);

  static saveUserData(User user){
    Console.log("Hello i am here logging you.${user.id}");
    DataManager temp = DataManager._instance(value: user);
    DataManager? data = globalDataNotifier[USER_DATA];
    if(data != null){
      data.value = user;
    }else{
      DataManager.save(temp, USER_DATA);
    }
    
  }

  static save(DataManager data, String name){
    globalDataNotifier[name] = data;
  }

  static Map<String,DataManager> globalDataNotifier = {};
}