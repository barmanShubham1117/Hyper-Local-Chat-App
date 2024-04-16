import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justeasy/config/app_config.dart';
import 'package:justeasy/controllers/asset_controller.dart';
import 'package:justeasy/controllers/auth_controller.dart';
import 'package:justeasy/controllers/match_controller.dart';
import 'package:justeasy/controllers/nearby_controller.dart';
import 'package:justeasy/controllers/profile_controller.dart';
import 'package:justeasy/controllers/stream_controller.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/helpers/text_style.dart';
import 'package:justeasy/models/local_notification.dart';
import 'package:justeasy/models/notifiable.dart';
import 'package:justeasy/models/user.dart';
import 'package:justeasy/routes/route_controller.dart';
import 'package:justeasy/services/background_services.dart';
import 'package:justeasy/widgets/lines.dart';
import 'package:justeasy/widgets/popover_menu.dart';
import 'package:justeasy/widgets/user_cards.dart';
import 'package:location/location.dart' as FLocation;
import 'package:path/path.dart';
import 'package:redis/redis.dart';
import 'package:background_location/background_location.dart';
import 'package:star_menu/star_menu.dart';
import 'dart:math' as math;

class NearByScreen extends StatefulWidget {
  NearByScreen({ Key? key }) : super(key: key);

  @override
  _NearByScreenState createState() => _NearByScreenState();
}

ValueNotifier<bool> menuNotifier = ValueNotifier<bool>(false);
late ValueNotifier<User> userNotifier;
final ValueNotifier<int> isListUpdated = ValueNotifier<int>(0);
List<User> nearbyUsers = [];
List<User> gpsUsers = [];
String connectionIdentifier = 'nearby-id';

List<dynamic> block = [];


bool checkBlock(String id){
  bool checked = false;
  for(int i=0; i<block.length;i++){
    Console.log("${block[i]["blocked_user"]} - $id are same : ${block[i]["blocked_user"] == id}");
    if(block[i]["blocked_user"] == id) {
      Console.log("Blocked");
      return true;
    }
  }
  Console.log("Not bloocked");
  return checked;
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
  // if(event["action"] == "startGlobalChannel"){
  //     DataManager.connections[connectionIdentifier] = RedisConnection();
  //   LocalNotification localNotify = LocalNotification();
  //   Console.log("User id on nearby bg ${event['globalChannel']}");
  //     // StreamController.getGlobalListener(DataManager.connections[connectionIdentifier]??RedisConnection()).then((globalListner){
  //       StreamController.getRoomListener(DataManager.connections[connectionIdentifier]??RedisConnection(),event["globalChannel"]).then((globalListner){
  //       Console.log('-----------G------------reacted');
  //       globalListner.getStream().listen((message){
  //         Console.log('message');
  //         Console.log(message);
  //         if(message[2] != 1){
  //           Map<String,dynamic> messageMap = jsonDecode(message[2]);
  //           localNotify.showNotification(
  //             channel: "${math.Random()}", 
  //             channelDescription: "Channel for match notification", 
  //             channelName: "Match notification ${math.Random()}", 
  //             title: "You got a new connection.", 
  //             body: "${messageMap["message"]} .\n For more info open justeasy.",
  //           );
  //         }
  //         // Console.log(message[2]);
  //         // DataManager.notifyOrganizer.showNotification(
  //         //   channel: channel, 
  //         //   channelDescription: channelDescription, 
  //         //   channelName: channelName, 
  //         //   title: title, 
  //         //   body: body
  //         // );
          
          
  //         //show notification as per typ
  //         // if(notifiable.type == Notifiable.MatchNotifiable){
  //         //     MatchController.getNotificationsCount();
  //         // }
  //       });
  //     }).catchError((error){
  //       Console.log("===================EEEEEEEEEEErrrrrrrrrroooooooooooooorrrrrrrrrrr====================");
  //       Console.log(error);
  //     });
  // }
      if (event["action"] == "stopService") {
        service.stopBackgroundService();
      }
    });
     // bring to foreground
    service.setForegroundMode(false);
      // BackgroundLocation.getLocationUpdates((location) => NearByController.updateLocationBG(DataManager.user, location));
    
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!(await service.isServiceRunning())) timer.cancel();
      service.setNotificationInfo(
        title: "Just Easy is running on background.",
        content: "To ensure that you don't miss anyone around you. Click here to know more.",
      );
      Console.log(DataManager.user.id);
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
    BackgroundLocation().getCurrentLocation().then((location){
      
    // Console.log("Think it\'s nul!!");
    // if(location == null){
    //   LocalNotification().showNotification(channel: "No_location_com.justeasy", channelDescription: "no location info", 
    //   channelName: "com.justeasy.noLocation", 
    //   title: 'Unable to update users around you.', body: 'Please turn on your location to see who\'s around you.');
    // }
    NearByController.updateLocationBG(DataManager.user, location);
    }).onError((error, stackTrace){
      Console.log(error);
    });
    // NearByController.getNearbyUsersBG().then((result){
    //   List<User> list = [];
    //   bool au = result.data['unauthenticated'] ?? false;
    //   if(au){
    //     service.stopBackgroundService();
    //   }else{
    //     // list = (result.data['users'] as List).map<User>((json)=>User.fromJson(json)).toList();
    //     service.sendData(
    //       {
    //         "users":(result.data['users'] as List),
    //       },
    //     );
    //   }
    // });
    });
  }

class _NearByScreenState extends State<NearByScreen> {

late Timer _timer;
final bg = BackgroundEx();
final FlutterBackgroundService service = FlutterBackgroundService();
LocalNotification? localNotify;
RedisConnection? redisConnection;

Stream<List<User>> getNearUsers() => Stream.periodic(
      const Duration(
        seconds: 1,
      ),
    ).asyncMap(
      (event) => NearByController.getNearbyUsersBG(),
    );
Stream<List<User>> getGpsUsers() => Stream.periodic(
      const Duration(
        seconds: 1,
      ),
    ).asyncMap(
      (event) => NearByController.getGpsUsersBG(),
    );
  // @override
  void initState(){
    Console.log("inititated with ${DataManager.user.id}");
    WidgetsFlutterBinding.ensureInitialized(); 
    BackgroundLocation.setAndroidNotification(
    	title: "Just Easy is running on background.",
        message: "To ensure that you don't miss anyone around you. Click here to know more.",
            icon: "@mipmap/ic_launcher",
    );
    BackgroundLocation.setAndroidConfiguration(1000);
    BackgroundLocation.startLocationService();
    BackgroundLocation.startLocationService(distanceFilter : 120);
    BackgroundEx.init(onStart);
    FlutterBackgroundService().sendData({
      "action":"startGlobalChannel",
      "globalChannel":DataManager.user.id,
    });
    super.initState();
  }
  
  @override
  void dispose() {
    FlutterBackgroundService().dispose();
    redisConnection?.close();
    super.dispose();
  }
  

  // @override
  // void deactivate() {
  //   timer.cancel();
  //   vtimer.cancel();
  //   super.deactivate();
  // }

  void initGlobal(BuildContext context){
    if(localNotify == null){
      if(redisConnection == null) redisConnection = RedisConnection();
      RedisConnection con = redisConnection??RedisConnection();
      StreamController.getRoomListener(con, DataManager.user.id).then((value){
        localNotify = LocalNotification(context);
        value.getStream().listen((message) { 
          if(message[2] != 1){
            Map<String,dynamic> messageMap = jsonDecode(message[2]);
            localNotify?.showNotification(
              channel: "${math.Random()}", 
              channelDescription: "Channel for match notification", 
              channelName: "Match notification ${math.Random()}", 
              title: "You got a new connection.", 
              body: "${messageMap["message"]} .\n For more info open justeasy.",
              payload:message[2],
            );
          }
        });
      }).onError((error, stackTrace){
        initGlobal(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);
    ScreenUtil().setWidth(360);
    ScreenUtil().setHeight(689);
    Constants constant = Constants(context);
    User user = DataManager.user;
    userNotifier = ValueNotifier(user);
    initGlobal(context);
    // FlutterBackgroundService().sendData({"action":"setAsBackground"});
    // Timer code
    NearByController.updateLocation(DataManager.user, FLocation.Location());
    MatchController.getNotificationsCount();
    NearByController.getBlockUser(context).then((list){
      Console.log("Logging block");
      block = list;
      Console.log(block);
    });
    NearByController.getNearbyUsers().then((response){
      service.sendData(
          {
            "users":(response.data['users'] as List),
          },
        );
    }).catchError((onError){Console.log(onError);});

    // FlutterBackgroundService().onDataReceived.listen((event) { 
    //   Console.log("listen");
    // });
    // Timer code ends
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        if(menuNotifier.value) menuNotifier.value = false;
      },
      child: ValueListenableBuilder(
        valueListenable: userNotifier,
        builder: (context, child, value){
          ScreenUtil.setContext(context);
          return SafeArea(
          child: Scaffold(
              backgroundColor:AppColors.primaryBG,
              resizeToAvoidBottomInset: true,
              // floatingActionButton: FloatingActionButton(
              //   onPressed: (){
              //     showBottomSheet(context: context, builder: (context){
              //       return Container(
              //         width:constant.screenWidth,
              //         height: constant.screenHeight * 0.5,
              //         decoration: BoxDecoration(
              //           color: AppColors.secondaryBG
              //         ),
              //       );
              //     });
              //   },
              //   backgroundColor:AppColors.secondaryBG,
              //   child: Icon(Icons.notifications,color: AppColors.primaryText),
              // ),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(constant.screenHeight * 0.1),
                child: Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(0),
                  // padding: EdgeInsets.only(top:constant.screenHeight * 0.01),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:EdgeInsets.all(5.w),
                          child:Image(
                            image: AssetController.getLogo,
                            height: constant.screenHeight * 0.04,
                          ),
                        ),
                        IconButton(
                            onPressed: (){
                              menuNotifier.value = !menuNotifier.value;
                            },
                            icon: Stack(
                              children:[
                                Icon(
                                  Icons.menu,
                                  color: AppColors.iconColor,
                                  size:constant.screenWidth * 0.08,
                                ).addStarMenu(context,
                                 [
                                   StarMenu(
                                     child: Container(
                                        width: constant.screenWidth * 0.8,
                                        height: 300.h,
                                        margin:EdgeInsets.only(top:30.h,right:constant.screenWidth * 0.05),
                                        // padding: EdgeInsets.only(top:constant.screenHeight * 0.05),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondaryBG,
                                          borderRadius: BorderRadius.circular(constant.screenHeight * 0.03)
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment:MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(constant.screenHeight * 0.5),
                                                  child: Image.network(
                                                    '${AppConfig.mainUrl}/${userNotifier.value.image}',
                                                    width: constant.screenWidth * 0.2,
                                                    height: constant.screenWidth * 0.2,
                                                    fit: BoxFit.fill,
                                                    errorBuilder: (x,y,z){
                                                      return Image.asset(
                                                        AssetController.dummyProfile,
                                                        width: constant.screenWidth * 0.15,
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  margin:EdgeInsets.only(top:30.h),
                                                  child:Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  // mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      userNotifier.value.name,
                                                      style:AppTextStyle.profileName(constant).copyWith(
                                                        fontSize: 15.sp,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width:constant.screenWidth * 0.4,
                                                          child: Text(
                                                            user.user_id,
                                                            style:AppTextStyle.profileID(constant),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: (){
                                                            Clipboard.setData(ClipboardData(text:user.user_id));
                                                          },
                                                          icon: Icon(Icons.copy,color: AppColors.secondaryText,size: constant.screenHeight * 0.025,),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                ),
                                              ],
                                            ),
                                            PopOverMenu.menu(
                                              context:context,
                                              constant: constant,
                                              icon: Icons.people,
                                              onClick:AppRouteController.gotoProfilePage,
                                              text: 'My Profile'
                                            ),
                                            PopOverMenu.menu(
                                              context:context,
                                              constant: constant,
                                              icon: Icons.notifications,
                                              onClick:AppRouteController.gotoNotificationScreen,
                                              text: 'Notifications'
                                            ),
                                            PopOverMenu.menu(
                                              context:context,
                                              constant: constant,
                                              icon: Icons.settings,
                                              onClick: AppRouteController.gotoSettingScreen,
                                              text: 'Settings'
                                            ),
                                            PopOverMenu.menu(
                                              context:context,
                                              constant: constant,
                                              icon: Icons.share,
                                              onClick: AppRouteController.gotoShareScreen,
                                              text: 'Share App'
                                            ),
                                            
                                            Container(
                                              width:constant.screenWidth,
                                              padding:const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top:BorderSide(width: constant.screenHeight * 0.001, color: AppColors.mutedColor),
                                                ),
                                              ),
                                              child: PopOverMenu.menu(
                                                context:context,
                                                constant: constant,
                                                icon: Icons.arrow_back,
                                                onClick: AuthController.logout,
                                                text: 'Log Out'
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                      
                                   ),
                                 ],
                                  StarMenuParameters(
                                    onItemTapped: (index,controller){
                                         controller.closeMenu();
                                       }
                                  )
                                ),
                                // Visibility(
                                //   visible:DataManager.notificationNotifier.value > 0,
                                //   child:CircleAvatar(
                                //     radius: 8,
                                //     backgroundColor: AppColors.badgeColor,
                                //     child:Text(
                                //       DataManager.notificationNotifier.value.toString(),
                                //       textAlign:TextAlign.center,
                                //       style: TextStyle(
                                //         fontSize: 10,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: Stack(
                children:[
                  SingleChildScrollView(
                    child:Column(
                          children:[
                            Container(
                              decoration:BoxDecoration(
                                color:AppColors.secondaryBG,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              padding: EdgeInsets.only(top: constant.screenHeight * 0.02),
                              child: Column(
                                children: [
                                  Line.horizonalLineHeading(constant, Color(0xFFE8E6EA), 'Near You'),
                                  StreamBuilder<List<User>>(
                                  // valueListenable: isListUpdated,
                                  // stream: FlutterBackgroundService().onDataReceived,
                                  stream: getNearUsers(),
                                  builder: (context, snapshot){
                                    ScreenUtil.setContext(context);
                                      if(snapshot.hasData){
                                        final data = snapshot.data!;
                                        nearbyUsers = data;
                                        Console.log("arriving properly...");
                                      }
                                      return Container(
                                        
                                        width: constant.screenWidth,
                                        height: constant.screenHeight * 0.38,
                                        padding:EdgeInsets.only(left:6,right:6,top:10,bottom:10),
                                        child: nearbyUsers.length > 0 
                                          ? GridView.count(
                                          crossAxisCount: 2,
                                          padding: const EdgeInsets.all(10),
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing:20,
                                          childAspectRatio:( constant.screenHeight/constant.screenWidth * 0.52),
                                          scrollDirection: Axis.horizontal,
                                          children: List.generate(nearbyUsers.length, (index) => UserCards.nearUserCard(context,user: nearbyUsers[index],block:block,isBlocked:checkBlock(nearbyUsers[index].id)))
                                          // ? List.generate(nearbyUsers.length, (index) => UserCards.nearUserCard(context,user: nearbyUsers[index]))
                                          // : List.generate(10, (index) => UserCards.nearUserCard(context,dummy: true))
                                        )
                                        : Container(
                                          padding:EdgeInsets.all(10),
                                          child: Center(
                                            child:Text(
                                              'We are checking users around you. All users near a radius of 120m will be shown here.\n \n In case you unable to see user please check if your profile picture update properly.',
                                              textAlign:TextAlign.center,
                                              style: GoogleFonts.roboto(
                                                fontSize: 15.sp
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: AppColors.primaryBG,
                              padding: EdgeInsets.only(top: constant.screenHeight * 0.02),
                              child: Column(
                                children: [
                                  Line.horizonalLineHeading(constant, Color(0xFFE8E6EA), 'With in GPS range'),
                                  StreamBuilder<List<User>>(
                                  // valueListenable: isListUpdated,
                                  // stream: FlutterBackgroundService().onDataReceived,
                                  stream: getGpsUsers(),
                                  builder: (context, snapshot){
                                    ScreenUtil.setContext(context);
                                      if(snapshot.hasData){
                                        final data = snapshot.data!;
                                        gpsUsers = [];
                                        data.forEach((element) { 
                                          var dist = double.parse("${element.distance}");
                                          if(dist <= 120 && element.points.altitude! >= (DataManager.location["altitude"]??0 - 10) && element.points.altitude! <= (DataManager.location["altitude"]??0 + 10)){
                                            Console.log("Catched and nulled!!");
                                          }else{
                                            Console.log("${DataManager.location["altitude"]} is altitude");
                                            gpsUsers.add(element);
                                          }
                                        });
                                        // gpsUsers = data;
                                        Console.log("arriving properly...");
                                      }
                                      return SizedBox(
                                        width: constant.screenWidth,
                                        height: constant.screenHeight * 0.38,
                                        child: gpsUsers.length > 0 
                                          ? GridView.count(
                                          crossAxisCount: 2,
                                          padding: const EdgeInsets.all(10),
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing:10,
                                          childAspectRatio:( constant.screenHeight/constant.screenWidth * 0.55),
                                          scrollDirection: Axis.horizontal,
                                          children: List.generate(gpsUsers.length, (index) => UserCards.nearUserCard(context,user: gpsUsers[index], gps: true, block:block,isBlocked:checkBlock(user.id)))
                                          // ? List.generate(nearbyUsers.length, (index) => UserCards.nearUserCard(context,user: nearbyUsers[index]))
                                          // : List.generate(10, (index) => UserCards.nearUserCard(context,dummy: true))
                                        )
                                        : Container(
                                          padding:EdgeInsets.all(10),
                                          child: Center(
                                            child:Text(
                                              'We are checking users around you. All users near a radius of 1.2km will be shown here.\n \n In case you unable to see user please check if your profile picture update properly.',
                                              textAlign:TextAlign.center,
                                              style:TextStyle(
                                                color:AppColors.secondaryBG,
                                                fontSize: 15.sp
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  ),
                                ],
                              ),
                            )
                          ]
                        ),
                  ),
                  // ValueListenableBuilder(
                  //   valueListenable: menuNotifier,
                  //   builder: (context,child,value)=>Visibility(
                  //     visible: menuNotifier.value,
                  //     child: Positioned(
                  //       right: 10,
                  //       top: 10,
                  //       child: Container(
                  //         width: constant.screenWidth * 0.8,
                  //         height: constant.screenHeight * 0.5,
                  //         // padding: EdgeInsets.only(top:constant.screenHeight * 0.05),
                  //         decoration: BoxDecoration(
                  //           color: AppColors.secondaryBG,
                  //           borderRadius: BorderRadius.circular(constant.screenHeight * 0.03)
                  //         ),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           mainAxisAlignment:MainAxisAlignment.spaceAround,
                  //           children: [
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //               children: [
                  //                 ClipRRect(
                  //                   borderRadius: BorderRadius.circular(constant.screenHeight * 0.5),
                  //                   child: Image.network(
                  //                     '${AppConfig.mainUrl}/${userNotifier.value.image}',
                  //                     width: constant.screenWidth * 0.2,
                  //                     height: constant.screenWidth * 0.2,
                  //                     fit: BoxFit.fill,
                  //                     errorBuilder: (x,y,z){
                  //                       return Image.asset(
                  //                         AssetController.dummyProfile,
                  //                         width: constant.screenWidth * 0.15,
                  //                       );
                  //                     },
                  //                   ),
                  //                 ),
                  //                 Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   // mainAxisAlignment: MainAxisAlignment.end,
                  //                   children: [
                  //                     Text(
                  //                       userNotifier.value.name,
                  //                       style:AppTextStyle.profileName(constant).copyWith(
                  //                         fontSize: 15,
                  //                       ),
                  //                     ),
                  //                     Row(
                  //                       mainAxisAlignment: MainAxisAlignment.start,
                  //                       children: [
                  //                         Container(
                  //                           width:constant.screenWidth * 0.4,
                  //                           child: Text(
                  //                             user.user_id,
                  //                             style:AppTextStyle.profileID(constant),
                  //                             overflow: TextOverflow.ellipsis,
                  //                           ),
                  //                         ),
                  //                         IconButton(
                  //                           onPressed: (){
                  //                             Clipboard.setData(ClipboardData(text:user.user_id));
                  //                           },
                  //                           icon: Icon(Icons.copy,color: AppColors.secondaryText,size: constant.screenHeight * 0.025,),
                  //                         ),
                  //                       ],
                  //                     )
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //             PopOverMenu.menu(
                  //               context:context,
                  //               constant: constant,
                  //               icon: Icons.people,
                  //               onClick:AppRouteController.gotoProfilePage,
                  //               text: 'My Profile'
                  //             ),
                  //             PopOverMenu.menu(
                  //               context:context,
                  //               constant: constant,
                  //               icon: Icons.notifications,
                  //               onClick:AppRouteController.gotoNotificationScreen,
                  //               text: 'Notifications'
                  //             ),
                  //             PopOverMenu.menu(
                  //               context:context,
                  //               constant: constant,
                  //               icon: Icons.settings,
                  //               onClick: AppRouteController.gotoSettingScreen,
                  //               text: 'Settings'
                  //             ),
                  //             PopOverMenu.menu(
                  //               context:context,
                  //               constant: constant,
                  //               icon: Icons.share,
                  //               onClick: AppRouteController.gotoShareScreen,
                  //               text: 'Share App'
                  //             ),
                  //             Container(
                  //               width:constant.screenWidth,
                  //               padding:const EdgeInsets.all(15),
                  //               decoration: BoxDecoration(
                  //                 border: Border(
                  //                   top:BorderSide(width: constant.screenHeight * 0.001, color: AppColors.mutedColor),
                  //                 ),
                  //               ),
                  //               child: PopOverMenu.menu(
                  //                 context:context,
                  //                 constant: constant,
                  //                 icon: Icons.arrow_back,
                  //                 onClick: AuthController.logout,
                  //                 text: 'Log Out'
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                      
                  //     ),
                  //   ),
                  // ),
                
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
