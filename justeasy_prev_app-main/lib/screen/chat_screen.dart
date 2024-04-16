import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justeasy/config/app_config.dart';
import 'package:justeasy/controllers/asset_controller.dart';
import 'package:justeasy/controllers/chat_controller.dart';
import 'package:justeasy/controllers/nearby_controller.dart';
import 'package:justeasy/controllers/profile_controller.dart';
import 'package:justeasy/controllers/stream_controller.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/helpers/notify.dart';
import 'package:justeasy/helpers/text_style.dart';
import 'package:justeasy/models/api_response.dart';
import 'package:justeasy/models/chat_data.dart';
import 'package:justeasy/models/social.dart';
import 'package:justeasy/models/user.dart';
import 'package:justeasy/routes/route_controller.dart';
import 'package:justeasy/widgets/chat_message.dart';
import 'package:justeasy/models/message.dart';
import 'package:justeasy/widgets/lines.dart';
import 'package:redis/redis.dart';
import 'package:sheet/sheet.dart';
import 'dart:math' as math;

import 'package:star_menu/star_menu.dart';

List<ChatData> msgs = [];

final TextEditingController messageController = TextEditingController();
final ValueNotifier<int> messageNotifier = ValueNotifier(0);
final ScrollController scrollController = ScrollController();
final TextEditingController reportController = TextEditingController();

DateTime? deletedAt;

PubSub? chatListener;
bool isListening = false;
List<Social> social = [];

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future<bool> pushMessage(context, room, User user, int type, String data) async {
      ChatData d = ChatData(
          type: type,
          data: data,
          readAt: '',
          room: room.toString(),
          sentBy: user.id,
          id: "${msgs.length}",
          sentAt: "${DateTime.now().hour}:${DateTime.now().minute}");
      msgs.add(d);
      var id = msgs.length - 1;
      messageNotifier.value = messageNotifier.value++;
      ChatController.pushMessage(context, room["_id"], data, type)
          .then((value) {
        ApiResponse response = value;
        if (response.success) {
          msgs[id] = ChatData.fromJson(response.data["message"]);
          messageNotifier.value = messageNotifier.value++;
          try{
            scrollController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
          }catch(e){
            Console.log(e);
          }
        }
      });
      return true;
  }

  Timer? ticker;

  ValueNotifier<int> tickerNotifier = ValueNotifier(120);
  RedisConnection? con;
  
  void startListener(String room){
    WidgetsFlutterBinding.ensureInitialized();
    StreamController.getRoomListener(con??RedisConnection(), room).then((value){
        chatListener = value;
        chatListener?.getStream().listen((event) {
          Console.log("logging event");
          Console.log(event[2], r: true);
          try{
            ChatData message = ChatData.fromJson(jsonDecode(event[2]));
            if (message.sentBy != DataManager.user.id) {
              msgs.add(message);
              messageNotifier.value = messageNotifier.value++;
              scrollController.animateTo(
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            }
          }catch(e){
            Console.log("chat errror");
            Console.log(e);
          }
        });
      }).onError((error, stackTrace){
        startListener(room);
      });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      var roomm = Constants(context).passedData["room"];
      con = con??RedisConnection();
      startListener(roomm['_id']);
      ChatController.pullChat(context, roomm['_id']).then((response) {
      msgs = response;
      messageNotifier.value = messageNotifier.value++;
      // Console.log(response[0].data, r: true);
    });
    });
  }

//   @override
void didChangeDependencies() {
    // Provider.of<>(context)
    //  isListening = true;
    //   var roomm = Constants(context).passedData["room"];
    //   con = con??RedisConnection();
    //   chatListener = StreamController.getRoomListener(con??RedisConnection(), roomm['_id']);
    //   if(!isListening){
    //     isListening = true;
    //     chatListener?.then((value) {
    //     PubSub listener = value;
    //     listener.getStream().listen((event) {
    //       Console.log("logging event");
    //       Console.log(event[2], r: true);
    //       ChatData message = ChatData.fromJson(jsonDecode(event[2]));
    //       if (message.sentBy != DataManager.user.id) {
    //         msgs.add(message);
    //         messageNotifier.value = !messageNotifier.value;
    //         scrollController.animateTo(
    //           0.0,
    //           curve: Curves.easeOut,
    //           duration: const Duration(milliseconds: 300),
    //         );
    //       }
    //     });
    //   }).catchError((onError) => Console.log(onError, r: true));
    //   }
    super.didChangeDependencies();
}

  @override
  void dispose() {
    // TODO: implement dispose
    con?.close();
    isListening = false;
    msgs = [];
    super.dispose();
  }

bool isme = true;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);
    Constants constant = Constants(context);
    User user = DataManager.user;
    User second = constant.passedData["second"];
    Map<String,dynamic> room = constant.passedData["room"];
    Social? socialt = constant.passedData["social"];

    Console.log('${AppConfig.mainUrl}/${second.image}');

    
    

    DateTime time = DateTime.parse(room["createdAt"]);
    DateTime currentTime = DateTime.now();
    var secs = currentTime.difference(time).inSeconds;
    tickerNotifier.value = 120-secs ;
    if(tickerNotifier.value < 0){
      AppRouteController.goBack(context);
      Notify(context: context, type: 'error', messageType: Notify.TEXTNOTIFICATION, message: "Chat ended.");
    }
    Console.log("loggin time : ${time.hour}");
    if(ticker != null) ticker?.cancel();
    ticker = Timer.periodic(Duration(seconds: 1), (timer) {
      if(tickerNotifier.value - 1 != 0)tickerNotifier.value-=1;
      else{
        timer.cancel();
        AppRouteController.goBack(context);
        Notify(context: context, type: 'error', messageType: Notify.TEXTNOTIFICATION, message: "Chat ended.");
      };
    });

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });

if(socialt!=null && isme){
      isme = false;
      pushMessage(context, room, user, 1,socialt.toString()).then((value){
        messageNotifier.value = messageNotifier.value++ ;
      });
    }
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(constant.appBarSize * 1.5),
          child: Container(
            // padding: EdgeInsets.all(20),
            decoration: const BoxDecoration(color: AppColors.primaryBG),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackButton(),
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: constant.screenWidth * 0.1,
                      height: constant.screenWidth * 0.1,
                      child:ClipRRect(
                        borderRadius:BorderRadius.circular(constant.screenHeight),
                        child:Image.network(
                          '${AppConfig.mainUrl}/${second.image}',
                            errorBuilder: (e,c,x){
                              Console.log('${AppConfig.mainUrl}/${second.image}');
                              return Image.asset(AssetController.dummyProfile);
                            },
                            fit: BoxFit.fill,
                          ),
                        ),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 2,
                            offset: Offset(0,2)
                          ),
                        ],
                        shape: BoxShape.circle,
                        color: AppColors.mutedColor,
                        // image: DecorationImage(
                        //   image: NetworkImage(
                        //       '${AppConfig.mainUrl}/${second.image}'),
                        //       onError:(e,c){
                        //         Console.log(e);
                        //         Console.log(c);
                        //       }
                        // ),
                      ),
                    ),
                    SizedBox(
                      width: 100.w,
                      child: Text(
                        second.nickName,
                        overflow: TextOverflow.ellipsis,
                        style: constant.textTheme.headline2
                            ?.copyWith(fontSize: 24.sp),
                      ),
                    ),
                  ],
                ),
                 SizedBox(
                  width: 50.w,
                ),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: const Color(0x80FFFFFF),
                          borderRadius: BorderRadius.circular(5)),
                      child: ValueListenableBuilder(
                        valueListenable: tickerNotifier,
                        builder: (context, child, value){
                          ScreenUtil.setContext(context);
                          var color = AppColors.success;
                          
                          if(tickerNotifier.value<30) color = AppColors.error;
                          else if(tickerNotifier.value<60) color = AppColors.info;
                          return Text(
                          '${tickerNotifier.value} sec left',
                          style: GoogleFonts.roboto(
                            textStyle:  TextStyle(
                             fontWeight: FontWeight.normal, 
                             color: color,
                             fontSize: 12.sp)
                            ),
                        );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 3, bottom: 3, left:2, right:2),
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(2)),
                      child: Icon(
                          Icons.more_vert,
                          size:constant.screenHeight * 0.02,
                        ),
                      ).addStarMenu(context, [
                          StarMenu(
                            child: Container(
                              width: constant.screenWidth * 0.35,
                              height: constant.screenHeight * 0.2,
                              padding: EdgeInsets.all(5),
                              margin:EdgeInsets.only(top:30.h),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryBG,
                                borderRadius:BorderRadius.circular(constant.screenWidth * 0.05)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap:()async{
                                      
                                      var bsc = context;
                                      var asc = context;
                                      showDialog(context: context, builder: (context){
                                        ScreenUtil.setContext(context);
                                        bsc = context;
                                        return AlertDialog(
                                          content: Text(
                                            "Do you really want to end this chat?",
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children:[
                                                FlatButton(onPressed: ()async{
                                                ApiResponse r = await ChatController.endChat(context, room["_id"]);
                                                // if(r.success) {
                                                  Navigator.pop(context);
                                                  Navigator.pop(asc);
                                                // }
                                            }, child: Text(
                                              'Yes',
                                              style: GoogleFonts.roboto(
                                                fontSize:15.sp,
                                                color: Colors.white
                                              ),
                                            ),
                                            color: AppColors.buttonColor,
                                          ),
                                            FlatButton(onPressed: ()async{
                                              Navigator.pop(bsc);
                                            }, child: Text(
                                              'No',
                                               style: GoogleFonts.roboto(
                                                fontSize:15.sp,
                                                color: AppColors.buttonColor
                                              ),
                                            ),
                                            color: AppColors.buttonColor.withOpacity(0.2),
                                          )
                                              ],
                                            ),
                                          ],
                                        );
                                      });
                                    },
                                    child:Text("End chat",
                                      style:GoogleFonts.ptSans(
                                        fontSize: 17.sp,
                                        fontWeight:FontWeight.normal,
                                        color: AppColors.primaryText 
                                      ),
                                    ),
                                  ),
                                  Line.horizontalLine(Size(constant.screenWidth * 0.3,constant.screenWidth * 0.005),AppColors.placeholderColor.withOpacity(0.5)),
                                  InkWell(
                                    onTap:()async{
                                     
                                      var bsc = context;
                                      var asc = context;
                                      showDialog(context: context, builder: (context){
                                        ScreenUtil.setContext(context);
                                        bsc = context;
                                        return AlertDialog(
                                          content: Text(
                                            "Do you really want to block this user?",
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children:[
                                                FlatButton(onPressed: ()async{
                                               ApiResponse r = await NearByController.blockUser(context, second.user_id);
                                              if(r.success) {
                                                Navigator.pop(bsc);
                                                Navigator.pop(asc);
                                              }
                                            }, child: Text(
                                              'Yes',
                                              style: GoogleFonts.roboto(
                                                fontSize:15.sp,
                                                color: Colors.white
                                              ),
                                            ),
                                            color: AppColors.buttonColor,
                                          ),
                                            FlatButton(onPressed: ()async{
                                              Navigator.pop(bsc);
                                            }, child: Text(
                                              'No',
                                               style: GoogleFonts.roboto(
                                                fontSize:15.sp,
                                                color: AppColors.buttonColor
                                              ),
                                            ),
                                            color: AppColors.buttonColor.withOpacity(0.2),
                                          )
                                              ],
                                            ),
                                          ],
                                        );
                                      });
                                    },
                                    child:Text("Block",
                                      style:GoogleFonts.ptSans(
                                        fontSize: 17.sp,
                                        fontWeight:FontWeight.normal,
                                        color: AppColors.primaryText 
                                      ),
                                    ),
                                  ),
                                  Line.horizontalLine(Size(constant.screenWidth * 0.3,constant.screenWidth * 0.005),AppColors.placeholderColor.withOpacity(0.5)),
                                  InkWell(
                                    onTap:(){
                                      
                                       var bsc = context;
                                      showDialog(context: context, builder: (context){
                                        ScreenUtil.setContext(context);
                                        bsc = context;
                                        return AlertDialog(
                                          content: Text(
                                            "Do you really want to delete chat?",
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children:[
                                                FlatButton(onPressed: ()async{
                                                deletedAt = DateTime.now();
                                                messageNotifier.value = messageNotifier.value++;
                                                Navigator.pop(bsc);
                                            }, child: Text(
                                              'Yes',
                                              style: GoogleFonts.roboto(
                                                fontSize:15.sp,
                                                color: Colors.white
                                              ),
                                            ),
                                            color: AppColors.buttonColor,
                                          ),
                                            FlatButton(onPressed: ()async{
                                              Navigator.pop(bsc);
                                            }, child: Text(
                                              'No',
                                               style: GoogleFonts.roboto(
                                                fontSize:15.sp,
                                                color: AppColors.buttonColor
                                              ),
                                            ),
                                            color: AppColors.buttonColor.withOpacity(0.2),
                                          )
                                              ],
                                            ),
                                          ],
                                        );
                                      });
                                    },
                                    child:Text("Delete chat",
                                      style:GoogleFonts.ptSans(
                                        fontSize: 17.sp,
                                        fontWeight:FontWeight.normal,
                                        color: AppColors.primaryText 
                                      ),
                                    ),
                                  ),
                                  Line.horizontalLine(Size(constant.screenWidth * 0.3,constant.screenWidth * 0.005),AppColors.placeholderColor.withOpacity(0.5)),
                                  InkWell(
                                    onTap:()async{
                                      var dialog = await showDialog(
                                        context:context,
                                        builder: (context){
                                          ScreenUtil.setContext(context);
                                          return AlertDialog(
                                            actions: [
                                               FlatButton(
                                                   onPressed:()async{
                                                     Navigator.pop(context,true);
                                                   },
                                                   color: AppColors.buttonColor,
                                                   child: Text(
                                                      'Report',
                                                      style: GoogleFonts.roboto(
                                                        color: AppColors.secondaryBG,
                                                        fontSize: 15.sp,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                               ),
                                            ],
                                            content: Container(
                                            width: constant.screenWidth,
                                            height:constant.screenWidth * 0.5,
                                            decoration: BoxDecoration(
                                              color: AppColors.secondaryBG,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child:Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Mention the specific reason for REPORT',
                                                  textAlign:TextAlign.center,
                                                  style: GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Container(
                                                  width: constant.screenWidth * 0.8,
                                                  height: constant.screenWidth * 0.15,
                                                  padding:EdgeInsets.all(10),
                                                  alignment:Alignment.bottomCenter,
                                                  color: AppColors.placeholderColor.withOpacity(0.3),
                                                  child:TextFormField(
                                                    controller: reportController,
                                                    decoration:InputDecoration(
                                                      border: InputBorder.none
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          );
                                          
                                        },
                                        
                                      );
                                      if(dialog??false){
                                        bool r =  await ChatController.reportChat(context, second.user_id, reportController.text, room["_id"]);
                                        if(r) {
                                          ApiResponse r = await ChatController.endChat(context,room["_id"]);
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                    child:Text("Report",
                                      style:GoogleFonts.ptSans(
                                        fontSize: 17.sp,
                                        fontWeight:FontWeight.normal,
                                        color: AppColors.primaryText 
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ], StarMenuParameters(
                          onItemTapped: (index,controller){
                            controller.closeMenu();
                          }
                        )),
                    
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              // color: AppColors.primaryText,
              // width: constant.screenWidth,
              // height: constant.screenHeight * 0.75,
              child: SingleChildScrollView(
                controller: scrollController,
                reverse: true,
                child: ValueListenableBuilder(
                  valueListenable: messageNotifier,
                  builder: (context, value, child) {
                    List<ChatData> nmsgs = msgs;
                    if(deletedAt!=null){
                      nmsgs = [];
                      msgs.forEach((element) { 
                        var t = DateTime.parse(element.sentAt).difference(deletedAt!).inSeconds;
                        Console.log(t);
                        if(t >= 0)nmsgs.add(element);
                      });
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                          nmsgs.length,
                          (index){
                            return nmsgs[index].renderMessage(context,constant);
                          })
                    );
                  },
                ),
              ),
            ),
            // BottomSheet(
            //   onClosing: (){

            //   },
            //   builder:(context)=>Container(
            //     width: constant.screenWidth,
            //     height: constant.screenHeight * 0.1,
            //     color: AppColors.primaryBG,
            //   ),
            // ),
            Container(
              width: constant.screenWidth,
              height: constant.screenHeight * 0.09,
              color: AppColors.secondaryBG,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 250.w,
                    height: 30.h,
                    padding: EdgeInsets.only(left: 10,top:10.h),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.buttonColor),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: TextFormField(
                      controller: messageController,
                      onEditingComplete: () {
                        if(messageController.text.isNotEmpty){
                          pushMessage(context, room, user, 0, messageController.text);
                          messageController.text = '';
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Your message',
                        border:InputBorder.none,
                        focusedBorder:InputBorder.none,
                        hintStyle: AppTextStyle.placeholderText(constant)
                            .copyWith(color: AppColors.mutedColor),
                      ),
                    ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return Container(
                              width: constant.screenWidth,
                              height: constant.screenHeight * 0.4,
                              padding: EdgeInsets.only(top: constant.screenHeight * 0.05,bottom: constant.screenHeight * 0.02),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBG,
                                borderRadius:BorderRadius.only(
                                  topLeft: Radius.circular(constant.screenWidth * 0.1),
                                  topRight: Radius.circular(constant.screenWidth * 0.1),
                                ),
                              ),
                              child:FutureBuilder(
                                future: ProfileController.getActiveSocials(context),
                                builder: (context, snapshot){
                                  if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                    social = snapshot.data as List<Social>;
                                  }
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:constant.screenWidth,
                                        height: constant.screenHeight * 0.22,
                                        child:GridView.count(
                                          crossAxisCount: 2,
                                          padding: const EdgeInsets.all(10),
                                          crossAxisSpacing: 20,
                                          childAspectRatio: ((constant.screenWidth * 0.5)/(constant.screenHeight * 0.06)),
                                          mainAxisSpacing:12,
                                          scrollDirection: Axis.vertical,
                                          children: List.generate(social.length, (index){
                                            return InkWell(
                                              onTap: (){
                                                Console.log(social[index].toString());
                                                pushMessage(context, room, user, 1,social[index].toString());
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                decoration:BoxDecoration(
                                                  color: AppColors.secondaryBG,
                                                  borderRadius: BorderRadius.circular(constant.screenWidth * 0.015),
                                                ),
                                                child:Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children:[
                                                    Image.asset(
                                                      AssetController.socialList[social[index].type],
                                                      height:constant.screenHeight * 0.03,
                                                    ),
                                                    SizedBox(
                                                      width: constant.screenWidth * 0.03,
                                                    ),
                                                    Text(
                                                      social[index].name,
                                                      style:GoogleFonts.epilogue(
                                                        color:Color(0xFF555555),
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          })
                                          // ? List.generate(nearbyUsers.length, (index) => UserCards.nearUserCard(context,user: nearbyUsers[index]))
                                          // : List.generate(10, (index) => UserCards.nearUserCard(context,dummy: true))
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          pushMessage(context, room, user, 2,"Lets meet up");
                                          Navigator.pop(context);
                                        },
                                        child:Container(
                                          width: constant.screenWidth,
                                          height: constant.screenHeight * 0.06,
                                          margin: EdgeInsets.only(left:10,right:10),
                                          decoration:BoxDecoration(
                                            color: AppColors.secondaryBG,
                                            borderRadius: BorderRadius.circular(constant.screenWidth * 0.015),
                                          ),
                                          child:Center(
                                            child:Text(
                                              "Lets meet up!",
                                              style:GoogleFonts.allura(
                                                color:AppColors.secondaryText,
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          });
                    },
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: AppColors.secondaryBG,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.buttonColor,
                          )),
                      child: Container(
                        // padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: AppColors.buttonColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.buttonColor,
                            )),
                        child: Transform.rotate(
                          angle: -50 * math.pi / 180,
                          child: Icon(
                            Icons.attachment_outlined,
                            color: AppColors.secondaryBG,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if(messageController.text.isNotEmpty){
                          pushMessage(context, room, user, 0, messageController.text);
                          messageController.text = '';
                        }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: AppColors.buttonColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.buttonColor,
                          )),
                      child: const Icon(
                        Icons.send,
                        color: AppColors.secondaryBG,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
