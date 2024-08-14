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
    return BaseView(
        viewModel: myRoomViewModel,
        builder: (context, viewModel) => Scaffold(
              body: ListView.builder(
                itemCount: _mockRoomData().length,
                itemBuilder: (context, index) {
                  final RoomModel room = _mockRoomData()[index];
                  if (room.playerId == 1) {
                    return RoomItem(
                        room: room,
                        onReserve: () {
                          context
                              .read<LocalNotificationService>()
                              .scheduleNotification(
                                id: room.topicId,
                                title: room.roomId,
                                body: '채팅이 시작되었습니다.',
                                scheduledDateTime: room.startTime,
                              );
                        });
                  }
                },
              ),
            ));
  }

  List<RoomModel> _mockRoomData() {
    return [
      RoomModel(
        roomId: '테스트 방 1',
        startTime: DateTime.now().add(Duration(seconds: 30)),
        endTime: DateTime.now(),
        topicId: 101,
        playerId: '1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      RoomModel(
        roomId: '테스트 방 2',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        topicId: 102,
        playerId: '2',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
