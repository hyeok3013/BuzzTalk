import 'package:alarm_app/src/service/local_notification_service.dart';
import 'package:alarm_app/src/view/base_view.dart';
import 'package:alarm_app/src/view/home/home_view_model.dart';
import 'package:alarm_app/src/view/home/my_room/my_room_view.dart';
import 'package:alarm_app/src/view/home/room_list//room_list_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: HomeViewModel(),
      builder: (BuildContext context, HomeViewModel viewModel) => Scaffold(
        appBar: AppBar(
          title: const Text('방 목록'),
          actions: [
            IconButton(
              onPressed: () async {
                print('Navigate FilterView');

                // 필터 페이지로 이동하고, 필터 결과를 기다림
                final selectedTopicIds =
                    await context.push<List<int>>('/filter');

                if (selectedTopicIds != null) {
                  // 필터 결과를 RoomListView에 전달
                  viewModel.updateSelectedTopics(selectedTopicIds);
                }
              },
              icon: const Icon(Icons.filter_alt),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/create');
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: viewModel.currentIndex,
          onTap: viewModel.onTap,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '마이'),
          ],
        ),
        body: [
          RoomListView(selectedTopicIds: viewModel.selectedTopicIds),
          MyRoomView(),
        ].elementAt(viewModel.currentIndex),
      ),
    );
  }
}
