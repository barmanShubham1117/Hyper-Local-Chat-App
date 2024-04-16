import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:justeasy/helpers/constants.dart';

class PopOver extends StatelessWidget {
  final Size size;
  final Color backgroundColor;
  final ValueNotifier whenVisibleNotifier;
  final Widget child;
  PopOver({ Key? key, required this.size, required this.backgroundColor, required this.whenVisibleNotifier, required this.child }) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: whenVisibleNotifier,
      builder: (context,child,value)=>Visibility(
        visible: whenVisibleNotifier.value,
        child: Positioned(
          right: 10,
          top: 10,
          child: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(30)
            ),
            // child: child,
          ),
        ),
      ),
    );
  }
}