import 'package:flutter/services.dart';

class RunCode{
  final Function onStart;
  static const platform = MethodChannel("com.imaginar.justeasy/location");
  RunCode({required this.onStart});
}