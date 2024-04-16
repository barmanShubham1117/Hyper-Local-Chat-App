import 'package:flutter/widgets.dart';
import 'package:justeasy/models/user.dart';

class DataHandler extends InheritedWidget{

  final ValueNotifier userNotifier;
  final User user ;

  const DataHandler({Key? key, required Widget child, required this.userNotifier, required this.user}) : super(key: key, child: child);

  static User getUser(BuildContext context) => context.dependOnInheritedWidgetOfExactType<DataHandler>()!.user;

  static ValueNotifier getUserNotifier(BuildContext context) => context.dependOnInheritedWidgetOfExactType<DataHandler>()!.userNotifier;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    throw UnimplementedError();
  }

}