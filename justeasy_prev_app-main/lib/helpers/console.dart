import 'package:flutter/foundation.dart';

class Console{
  static void log(e,{bool r = false}){
    // hif(kDebugMode && r)
     print(e);
  }
}