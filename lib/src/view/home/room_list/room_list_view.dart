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
  late final RoomListViewModel roomListViewModel = RoomListViewModel(
    roomRepository: context.read(),
    localNotificationService: context.read(),
    sharedPreferencesRepository: context.read(),
  );

  @override
  void initState() {
    super.initState();
    // roomListViewModel.roomListFetch();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        viewModel: roomListViewModel,
        builder: (context, viewModel) => Scaffold(
              body: ListView.builder(
                itemCount: viewModel.roomList.length,
                itemBuilder: (context, index) {
                  final room = viewModel.roomList[index];
                  return RoomItem(
                    room: room,
                    onReserve: () => viewModel.bookScheduleChat(room),
                  );
                },
              ),
            ));
  }
}
