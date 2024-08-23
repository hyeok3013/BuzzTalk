import 'package:alarm_app/src/model/auth_model.dart';
import 'package:alarm_app/src/repository/auth_repository.dart';
import 'package:alarm_app/src/repository/http_request.dart';
import 'package:alarm_app/src/repository/room_repository.dart';
import 'package:alarm_app/src/repository/shared_preferences_repository.dart';
import 'package:alarm_app/src/repository/socket_repository.dart';
import 'package:alarm_app/src/repository/topic_repository.dart';
import 'package:alarm_app/src/view/create_room/create_room_view_model.dart';
import 'package:alarm_app/src/view/filter/topic_filter_view.dart';
import 'package:alarm_app/src/view/home/home_view.dart';
import 'package:alarm_app/src/view/chat/chat_view.dart';
import 'package:alarm_app/util/helper/route.dart';
import 'package:alarm_app/src/service/local_notification_service.dart';
import 'package:alarm_app/src/service/my_room_service.dart';
import 'package:alarm_app/src/service/topic_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

String ip = '119.203.5.249';
String serverUrl = 'http://$ip:3000';
String serverWsUrl = 'http://$ip:3001/chat';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  tz.initializeTimeZones();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => Http()),
        Provider(create: (context) => SharedPreferencesRepository(prefs)),
        Provider(create: (context) => AuthRepository(context.read<Http>())),
        Provider(create: (context) => SocketRepository(url: serverWsUrl)),
        Provider(create: (context) => LocalNotificationService()),
        Provider(create: (context) => RoomRepository(context.read<Http>())),
        Provider(create: (context) => TopicRepository(context.read<Http>())),
        Provider(create: (_) => AuthModel(playerId: '', password: '')),
        ChangeNotifierProvider(
            create: (context) =>
                CreateRoomViewModel(context.read<RoomRepository>())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'AirbnbCereal_W_Bk'),
      routerConfig: goRouter,
    );
  }
}
