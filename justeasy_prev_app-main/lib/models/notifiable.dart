import 'package:justeasy/helpers/console.dart';

class Notifiable{
  static const int MatchNotifiable = 0;
  static const int ConnectMatchNotifiable = 1;

  final int type;
  final Map<String,dynamic> data;
  final String readAt;
  final int notifiableType;

  Notifiable({required this.type, required this.notifiableType, required this.data, required this.readAt});

  static fromjson(json){
    return Notifiable(
      type : convertType(json['type']??0),
      notifiableType: resolveNotifiable(json['type']??0,json['notifiable_type']),
      data : json['data']??{},
      readAt : json['read_at']??'',
    );
  }

  static int convertType(type){
    switch(type){
      case 'MatchList' : return MatchNotifiable ;
      default : return MatchNotifiable ;

    }
  }
  static int resolveNotifiable(type,notifiable){
    if(type == MatchNotifiable && notifiable == ConnectMatchNotifiable) return ConnectMatchNotifiable ;
    return 0;
  }

}