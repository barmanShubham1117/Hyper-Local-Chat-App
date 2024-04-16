import 'package:justeasy/helpers/console.dart';
import 'package:location/location.dart';

class User{
  final String name, nickName, userName, email, dateOfBirth, status, location, image, user_id,id;
  LocationData points;
  final dynamic distance;
  User({
    required this.name,
    required this.nickName,
    required this.userName,
    required this.email,
    required this.dateOfBirth,
    required this.status,
    required this.location,
    required this.image,
    required this.user_id,
    required this.id,
    required this.points,
    required this.distance,
  });
  static User fromJson(final jsonData){

    Console.log(jsonData);
    return User(
      name:jsonData['name']??'',
      id: jsonData['user_id']??'',
      nickName:jsonData['nick_name']??'',
      userName:jsonData['user_name']??'',
      email:jsonData['email']??'',
      points:LocationData.fromMap(
        {
          'latitude':jsonData['latitude'],
          'longitude':jsonData['longitude'],
          'altitude':double.parse("${jsonData['altitude']??0}"),
        }
      ),
      dateOfBirth:jsonData['date_of_birth']??'',
      status:jsonData['status']??'',
      location:jsonData['name_location']??'',
      image:jsonData['current_profile']??'',
      user_id: jsonData['_id']??'',
      distance: jsonData['calcDistance']??0,
    );
  }
}