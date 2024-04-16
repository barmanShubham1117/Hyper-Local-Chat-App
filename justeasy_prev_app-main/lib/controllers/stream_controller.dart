import 'package:justeasy/config/app_config.dart';
import 'package:justeasy/helpers/console.dart';
import 'package:justeasy/helpers/data_manager.dart';
import 'package:redis/redis.dart';

class StreamController{

  static Future<PubSub> getGlobalListener(RedisConnection connection)async{
    Command command = await connection.connect(AppConfig.redis_host, int.parse(AppConfig.redis_port));
    final pubsub = PubSub(command);
    Console.log("Subscribing global channel : ${DataManager.user.id}");
    pubsub.subscribe([DataManager.user.id]);
    return pubsub;
  }

  static Future<PubSub> getRoomListener(RedisConnection connection, String room)async{
    Console.log("listening to ${room}");
    Command command = await connection.connect(AppConfig.redis_host, int.parse(AppConfig.redis_port));
    final pubsub = PubSub(command);
    pubsub.subscribe([room]);
    return pubsub;
  }

}