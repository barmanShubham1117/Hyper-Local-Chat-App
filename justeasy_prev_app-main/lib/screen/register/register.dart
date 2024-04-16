import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:justeasy/controllers/auth_controller.dart';
import 'package:justeasy/controllers/db_connector.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:justeasy/helpers/notify.dart';
import 'package:justeasy/routes/route_controller.dart';
import 'package:justeasy/screen/login/auth.dart';
import 'package:justeasy/widgets/buttons.dart';
import 'package:justeasy/widgets/form.dart';

class Register extends StatelessWidget {

Register({ Key? key }) : super(key: key);

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController emailController = TextEditingController(text: kDebugMode ? DataManager.EMAIL : '');
final TextEditingController nameController = TextEditingController(text: kDebugMode ? 'Ritika' : '');
final TextEditingController mobileController = TextEditingController(text: kDebugMode ? '9914173315' : '');
final TextEditingController passwordController = TextEditingController(text: kDebugMode ? '123456' : '');


void nextPage(context)async{
  var args = {
   'email' : emailController.text, 
   'mobile' : mobileController.text, 
   'name' : nameController.text, 
   'password' : passwordController.text
  };
    AuthController.registerUser(context, _formKey, args);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.setContext(context);
    Constants constant = Constants(context);
    // emailController.text = constant.passedData['email']??'';
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.secondaryBG,
        body: SingleChildScrollView(
          child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: constant.screenWidth * 0.05, right: constant.screenWidth * 0.1, bottom: constant.screenWidth * 0.05),
              // width: constant.screenWidth,
              // height: constant.screenHeight * 0.2,
              decoration: BoxDecoration(
                color: AppColors.primaryBG,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.w),
                  bottomRight: Radius.circular(15.w)
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BackButton(),
                  Text(
                    'Register',
                    style: constant.textTheme.headline3,
                  ),
                  Text(
                    'Register your account to connect with the community.',
                    style: constant.textTheme.subtitle1?.copyWith(
                      color: AppColors.secondaryText.withOpacity(0.49),
                    ),
                  ),
                ],
              ),
            ),
             Container(
                padding: EdgeInsets.only(top: 20.w),
                // height: constant.screenHeight * 0.6,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FormControl.input(
                        controller: emailController,
                        context: context, 
                        placeholder: 'Enter email id', 
                        constant: constant, 
                        type: TextInputType.emailAddress, 
                        validator: (value){
                          if(FormControl.emptyValidator(value) && FormControl.emailValidator(value)){
                            return null;
                          }else{
                            return !FormControl.emptyValidator(value) ? 'Email is mandatory' : 'Please enter a valid email.' ;
                          }
                        },
                      ),
                      FormControl.input(
                        controller: mobileController,
                        context: context, 
                        placeholder: 'Enter phone no.', 
                        constant: constant, 
                        type: TextInputType.phone, 
                        validator: (value){
                          if(!FormControl.emptyValidator(value)){
                            return 'Phone is mandatory...';
                          }
                          return null;
                        },
                      ),
                      FormControl.input(
                        controller: nameController,
                        context: context, 
                        placeholder: 'Enter name.', 
                        constant: constant,
                        validator: (value){
                          if(!FormControl.emptyValidator(value) || value.length < 3){
                            return 'Name is mandatory| min length : 3';
                          }
                          return null;
                        },
                      ),
                      FormControl.input(
                        controller: passwordController,
                        context: context, 
                        placeholder: 'Enter password.', 
                        constant: constant,
                        obscure: true,
                        validator: (value){
                          if(!FormControl.emptyValidator(value) || value.length < 6){
                            return 'Password is mandatory...';
                          }
                          return null;
                        },
                      ),
                      Buttons.largeButton(context,constant, 'Register', nextPage),
                    ],
                  ),
                ),
              ),
            
          ],
        ),
        ),
      ),
    );
  }
}