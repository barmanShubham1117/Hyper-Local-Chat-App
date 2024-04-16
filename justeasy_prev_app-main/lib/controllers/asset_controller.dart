import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:justeasy/config/app_config.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:lottie/lottie.dart';

class AssetController{
  static const getLogo = AssetImage('assets/images/logo.png');
  static const firstOnBoarding = AssetImage('assets/images/on_boarding/1.png');
  static const secondOnBoarding = AssetImage('assets/images/on_boarding/2.png');
  static const thirdOnBoarding = AssetImage('assets/images/on_boarding/3.png');
  static const fourthOnBoarding = AssetImage('assets/images/on_boarding/4.png');
  static const socialGoogle = AssetImage('assets/images/social/google.png');
  static const socialLinkedin = AssetImage('assets/images/social/Linkedin-Icon.png');

  static String customIcon = 'assets/images/social/custom.png';
  static String instagramIcon = 'assets/images/social/instagram.png';
  static String whatsappIcon = 'assets/images/social/whatsapp.png';
  static String linkedinIcon = 'assets/images/social/linkedin.png';
  static String facebookIcon = 'assets/images/social/facebook.png';

  static List socialList = [customIcon,instagramIcon,whatsappIcon,linkedinIcon,facebookIcon];

  static const shake = 'assets/images/icons/shake.png';

  static final loading = Lottie.asset('assets/anime/loading.json');

  static const dummyProfile = 'assets/images/empty/no_profile.jpg';

  static Image avatarImage(notifier,network){
    if(network){
      Console.log("network image ${notifier.value}");
      return Image.network("${notifier.value}",errorBuilder: (c,o,s){
        return Image.asset(dummyProfile,fit: BoxFit.cover,width: 100,);
      },);
    }
     if(notifier.value != AssetController.dummyProfile){
       return Image.file(File(notifier.value),fit: BoxFit.cover,);
     }
     return Image.asset(notifier.value);
  }
}