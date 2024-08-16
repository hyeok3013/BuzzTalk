import 'package:alarm_app/src/model/room_model.dart';
import 'package:alarm_app/src/service/local_notification_service.dart';
import 'package:alarm_app/src/service/my_room_service.dart';
import 'package:alarm_app/src/view/base_view.dart';
import 'package:alarm_app/src/view/home/my_room/my_room_view_model.dart';
import 'package:alarm_app/src/view/home/room_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyRoomView extends StatefulWidget {
  const MyRoomView({super.key});

  @override
  State<MyRoomView> createState() => _MyRoomViewState();
}

class _MyRoomViewState extends State<MyRoomView> {
  final MyRoomViewModel myRoomViewModel = MyRoomViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
