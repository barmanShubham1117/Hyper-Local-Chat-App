import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:justeasy/config/app_config.dart';
import 'package:justeasy/controllers/db_connector.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/notify.dart';
import 'package:justeasy/helpers/preference_manager.dart';
import 'package:justeasy/routes/route_controller.dart';
import 'package:justeasy/screen/login/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SocialWeb extends StatefulWidget {
  SocialWeb({ Key? key }) : super(key: key);

  @override
  _SocialWebState createState() => _SocialWebState();
}

class _SocialWebState extends State<SocialWeb> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);
    return Container(
        child: WebView(
          initialUrl: AppConfig.linkedinAuthUrl.toString(),
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (c)async{
            Console.log('intitiated');
            var url = c;
            var uri = Uri.parse(url);
            var code = uri.queryParameters['code'];
            Console.log(code!=null ? code : 'null params');
            if(code!=null) {
              var token = await DbConnector.getLinkedinToken(code);
              final CookieManager manager = CookieManager();
              manager.clearCookies();
              Notify(
                context: context,
                message: token.message,
                messageType: Notify.APINOTIFICATION,
                type: token.success ? 'success' : 'error', 
              );
              if(token.success || token.data['validError']==null){
                if(token.success){
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  PreferenceManager mana = PreferenceManager(pref);
                  mana.token = token.data['token'] ;
                  AppRouteController.gotoProfilePage(context,afterLogin: true);
                }else{
                  AppRouteController.goBack(context);
                }
              }else{
                AppRouteController.gotoRegisterPage(context,email: token.message['email'][0]);
              }
            }
          },
        ),
      );
  }
}