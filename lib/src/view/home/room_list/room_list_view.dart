import 'package:alarm_app/src/model/room_model.dart';
import 'package:alarm_app/src/service/local_notification_service.dart';
import 'package:alarm_app/src/service/my_room_service.dart';
import 'package:alarm_app/src/view/base_view.dart';
import 'package:alarm_app/src/view/home/room_list/room_list_view_model.dart';
import 'package:alarm_app/util/helper/infinite_scroll_mixin.dart';
import 'package:alarm_app/src/view/home/room_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RoomListView extends StatefulWidget {
  const RoomListView({super.key});

  @override
  State<RoomListView> createState() => _RoomListViewState();
}

class _RoomListViewState extends State<RoomListView> {
  late final RoomListViewModel roomListViewModel =
      RoomListViewModel(roomRepository: context.read());

  @override
  void initState() {
    super.initState();
    roomListViewModel.roomListFetch();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        viewModel: roomListViewModel,
        builder: (context, viewModel) => Scaffold(
              body: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        viewModel.roomListFetch();
                        print(viewModel.roomList);
                      },
                      child: Text('fetch')),
                  ElevatedButton(
                      onPressed: () {
                        viewModel.createRoom();
                        print(viewModel.roomList);
                      },
                      child: Text('create')),
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.roomList.length,
                      itemBuilder: (context, index) {
                        final room = viewModel.roomList[index];
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
                      },
                    ),
                  ),
                ],
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
