import 'package:flutter/material.dart';
import 'package:justeasy/config/app_config.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SocialModal{
  static AlertDialog socialModal(context){
    return AlertDialog(
      content: Container(
        child: WebView(
          initialUrl: AppConfig.linkedinAuthUrl.toString(),
          onWebViewCreated: (c)async{
            var url = await c.currentUrl();
            var uri = Uri.parse(url??'');
            Console.log('------------------${AppConfig.linkedinAuthUrl.toString()}');
            var code = uri.queryParameters['code'];
            Console.log(code!=null ? code : 'null');
            if(code!=null) Navigator.pop(context);
          },
        ),
      ),
    );
  }
}