  import 'package:justeasy/helpers/console.dart';

class MessageParser{
  List<String> message = [] ;
  MessageParser(Map<String,dynamic> message){
    Console.log(message);
    decodeErrors(message);
  }

  void decodeErrors(errors){
    errors.forEach((key, value) {
      message.add(errors[key][0]);
    });
  }
}