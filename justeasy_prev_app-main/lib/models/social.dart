import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justeasy/controllers/asset_controller.dart';
import 'package:justeasy/controllers/profile_controller.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/constants.dart';

class Social{
  final String name, value, id;
  final int type;
  final bool status;

  // static const SocialPlatform = [
  //   "Facebook":1,
  //   "Custom":0
  // ];

  Social({required this.name, required this.value, required this.id, required this.type, required this.status});

  static Social fromJson(jsonData){
    return Social(
      name: jsonData["name"]??'Custom',
      value: jsonData["url"]??'custom',
      id: jsonData["_id"]??"0",
      type: jsonData["type"]??0,
      status: jsonData["status"]??false,
    );
  }

  Widget render(Constants constant, ValueNotifier<bool>notifier){
    notifier.value = status;
    return Container(
      margin:EdgeInsets.only(bottom: constant.screenHeight * 0.01,),
      decoration: BoxDecoration(
        color: AppColors.secondaryBG,
        borderRadius:BorderRadius.circular(constant.screenWidth * 0.015),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Container(
            width: constant.screenWidth * 0.5,
            height: constant.screenHeight * 0.06,
            padding:EdgeInsets.only(left:constant.screenWidth * 0.05),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                // Transform.rotate(
                //   angle: skew,
                //   child:Icon(
                //     icon,
                //     color:AppColors.buttonColor,
                //   ),
                // ),
                Image.asset(
                  AssetController.socialList[type],
                  height:constant.screenHeight * 0.04,
                ),
                Padding(padding:EdgeInsets.only(left:constant.screenWidth * 0.05),),
                Text(
                  name,
                  textAlign:TextAlign.start,
                  style: GoogleFonts.epilogue(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Color(0xFF555555),
                  ),
                )
              ],
            ),
          ),
          ValueListenableBuilder(valueListenable: notifier, builder: (context, value, child)=>Switch(
            value: notifier.value,
            activeColor: AppColors.primaryText,
            onChanged: (bool value) {  
              notifier.value = value;
              ProfileController.updateSocial(context, this, notifier);
            },
          )),
        ],
      ),
    );
  }

  @override
  String toString(){
    Map<String,dynamic> map = {
      'name':name,
      'url':value,
      '_id':id,
      'type':type,
      'status':status
    };
    return jsonEncode(map);
  }
}