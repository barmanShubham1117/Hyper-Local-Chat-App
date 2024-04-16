import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:justeasy/helpers/console.dart';

class Constants{

  late Size _screenSize;
  late TextTheme _textTheme;
  late Map<String,dynamic> _passedData;

  Constants(BuildContext context){
    try{
      _screenSize = MediaQuery.of(context).size ;
      _passedData = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    }catch(e){
      Console.log(e);
    }
    _textTheme = Theme.of(context).textTheme ;
  }

  double get screenWidth{
    return _screenSize.width ;
  }

  double get screenHeight{
    return _screenSize.height ;
  }

  double get appBarSize{
    return _screenSize.height * 0.08 ;
  }

  TextTheme get textTheme{
    return _textTheme ;
  }

  Map<String,dynamic> get passedData{
    return _passedData;
  }

}