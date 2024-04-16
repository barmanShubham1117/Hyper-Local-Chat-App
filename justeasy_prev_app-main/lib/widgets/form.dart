import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';

class FormControl{
  static Widget input({
    required BuildContext context, 
    required String placeholder, 
    required Constants constant, 
    TextInputType type=TextInputType.text, 
    required Function validator,
    required TextEditingController controller,
    bool obscure = false
    }){
    return Container(
        margin: EdgeInsets.all(constant.screenHeight * 0.02),
        padding: EdgeInsets.only(left:constant.screenHeight * 0.02,right: constant.screenHeight * 0.02),
        decoration: BoxDecoration(
          color: AppColors.textFieldBG,
          borderRadius: BorderRadius.circular(constant.screenHeight)
        ),
        child: TextFormField(
          controller: controller,
          // key:emailKey,
          keyboardType:type,
          obscureText: obscure,
          validator: (value){
            return validator(value);
          },
          decoration: InputDecoration(
            hintText: placeholder,
            focusedBorder: InputBorder.none,
            border:InputBorder.none
          ),
        ),
      );
  }
  static Widget inputPlain({
    required BuildContext context, 
    required String placeholder, 
    required Constants constant, 
    TextInputType type=TextInputType.text, 
    required Function validator,
    required TextEditingController controller,
    bool obscure = false,
    bool enabled = true,
    }){
    return Container(
        margin: EdgeInsets.only(top: constant.screenHeight * 0.006, bottom: constant.screenHeight * 0.006),
        padding: EdgeInsets.only(left:constant.screenHeight * 0.02,right: constant.screenHeight * 0.02),
        decoration: BoxDecoration(
          color: AppColors.formTextFieldBG,
          borderRadius: BorderRadius.circular(constant.screenHeight * 0.01)
        ),
        child: TextFormField(
          controller: controller,
          enabled: enabled,
          // key:emailKey,
          keyboardType:type,
          obscureText: obscure,
          validator: (value){
            return validator(value);
          },
          decoration: InputDecoration(
            hintText: placeholder,
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
          ),
        ),
      );
  }

  static bool emailValidator(String value){
    return EmailValidator.validate(value);
    // return false;
  }

  static bool emptyValidator(String value){
    return value.isNotEmpty;
  }
}