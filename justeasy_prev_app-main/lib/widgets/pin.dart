import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:justeasy/helpers/app_colors.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/constants.dart';
import 'package:justeasy/helpers/text_style.dart';
class Pin extends StatelessWidget{
  final Constants constant;
  final int length ;
  List<dynamic> controllers = [];
  List<TextFormField> pins = [];
  List<FocusNode> focus = [];
  Pin({ Key? key, required this.constant, required this.length }){
    for(int i=0;i<length ; i++) {
      final TextEditingController tempController = TextEditingController();
      controllers.add(tempController);
      focus.add(FocusNode());
      pins.add(
        TextFormField(
              style: AppTextStyle.pinText(constant),
              textAlign: TextAlign.center,
              controller: controllers[i],
              focusNode: focus[i],
              showCursor: false,
              maxLines: 1,
              decoration: InputDecoration(
                focusColor: AppColors.buttonColor
                // focusedBorder:InputBorder.none,
                // border: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onChanged: (value){
                TextEditingController controller = controllers[i];
                int strlen = value.length;
                if(strlen > 1) {
                  controller.text = value.substring(value.length-1,value.length);
                  controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
                  
                }
                if(strlen == 1 && i<controllers.length){
                  focus[i+1].requestFocus();
                }else if(strlen == 0) {
                  focus[i-1].requestFocus();
                }
                
                Console.log(value.substring(0,1));
                Console.log(value);
              },
              enableInteractiveSelection: false,
            )
      );
      tempController.addListener(() { 
        listenableFunction(i);
      });
    }
  }

  void listenableFunction(n){
    TextEditingController controller = controllers[n] as TextEditingController ;
    TextEditingController nextController = controllers[n+1] as TextEditingController ;
    // TextEditingController prevController = controllers[n-1] as TextEditingController ;
    // if(controller.text.length >= 1) pins[n].
    Console.log(controller.text.length);
}

String getCode(){
  String code = '';
  controllers.forEach((element) {
    code+=element.text??'' ;
   });
   return code;
}
@override
  Widget build(BuildContext context) {
    
    return Container(
      padding: EdgeInsets.only(left: 20,right:20),
      width: constant.screenWidth * 0.8,
      height: constant.screenHeight * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(length, (index) =>
           Container(
            width: constant.screenWidth * 0.09,
            height: constant.screenHeight * 0.05,
            decoration: BoxDecoration(
              color: AppColors.textFieldBG.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2)
            ),
            child: Center(
              child: pins[index],
            ),
          )
        ),
    ),
    );
  }
}
