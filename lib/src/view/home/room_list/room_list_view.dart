import 'package:alarm_app/src/view/base_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alarm_app/src/view/home/room_list/room_list_view_model.dart';
import 'package:alarm_app/src/view/home/room_item.dart';
import 'package:alarm_app/util/helper/infinite_scroll_mixin.dart';

class RoomListView extends StatefulWidget {
  final List<int> selectedTopicIds;

  const RoomListView({super.key, required this.selectedTopicIds});

  @override
  State<RoomListView> createState() => _RoomListViewState();
}

class _RoomListViewState extends State<RoomListView> with InfiniteScrollMixin {
  late final RoomListViewModel roomListViewModel = RoomListViewModel(
    roomRepository: context.read(),
    localNotificationService: context.read(),
    sharedPreferencesRepository: context.read(),
  );

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    roomListViewModel.roomListFetch(
        topicIDList: widget.selectedTopicIds, limit: 5);
=======
    roomListViewModel.roomListFetch(widget.selectedTopicIds, context: context);
  }

  @override
  void onScrollEnd() {
    roomListViewModel.roomListFetch(widget.selectedTopicIds, context: context);
>>>>>>> d7d980ea6f6553f50b613b397e9edb9d757377b6
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
<<<<<<< HEAD
        viewModel: roomListViewModel,
        builder: (context, viewModel) => Scaffold(
              body: RefreshIndicator(
                onRefresh: () async {
                  await roomListViewModel.roomListFetch(
                      topicIDList: widget.selectedTopicIds);
                },
                child: ListView.builder(
                  itemCount: viewModel.roomList.length,
                  itemBuilder: (context, index) {
                    final room = viewModel.roomList.reversed.toList()[index];
                    return RoomItem(
                      room: room,
                      onReserve: () => viewModel.bookScheduleChat(room),
                      onCancel: () => viewModel.cancelScheduleChat(room),
                    );
                  },
                ),
              ),
            ));
=======
      viewModel: roomListViewModel,
      builder: (context, viewModel) => Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await roomListViewModel.roomListFetch(widget.selectedTopicIds,
                refresh: true, context: context);
          },
          child: ListView.builder(
            controller: scrollController, // 스크롤 컨트롤러 사용
            itemCount: viewModel.roomList.length + 1, // 로딩 인디케이터를 위한 추가 공간
            itemBuilder: (context, index) {
              if (index == viewModel.roomList.length) {
                // 마지막 항목에서 로딩 인디케이터를 보여줌
                if (viewModel.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return const SizedBox.shrink(); // 로딩 중이 아니면 빈 위젯
                }
              }

              final room = viewModel.roomList[index];
              return RoomItem(
                room: room,
                onReserve: () => viewModel.bookScheduleChat(room),
                onCancel: () => viewModel.cancelScheduleChat(room),
              );
            },
          ),
        ),
      ),
    );
>>>>>>> d7d980ea6f6553f50b613b397e9edb9d757377b6
  }
}
