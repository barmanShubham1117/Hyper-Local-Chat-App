import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:justeasy/controllers/asset_controller.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/routes/route_controller.dart';
import 'package:screen_loader/screen_loader.dart';

class Loading extends StatelessWidget {
   Loading({ Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);
    return Container(
        color: AppColors.loaderBackground,
        child: Center(
          child: AssetController.loading,
        ),
    );
  }
}