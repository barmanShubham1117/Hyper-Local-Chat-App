import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:justeasy/helpers/app_colors.dart';

class VerifyAccount extends StatefulWidget {
  VerifyAccount({ Key? key }) : super(key: key);

  @override
  _VerifyAccountState createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBG,
        body: Container(),
      ),
    );
  }
}