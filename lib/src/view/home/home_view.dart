import 'package:alarm_app/src/service/local_notification_service.dart';
import 'package:alarm_app/src/view/base_view.dart';
import 'package:alarm_app/src/view/home/home_view_model.dart';
import 'package:alarm_app/src/view/home/my_room/my_room_view.dart';
import 'package:alarm_app/src/view/home/room_list//room_list_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  final List<int> selectedTopicIds; // 필터된 주제 ID 목록
  const HomeView({super.key, required this.selectedTopicIds});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: HomeViewModel(),
      builder: (BuildContext context, HomeViewModel viewModel) => Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: Text(
            viewModel.currentIndex == 0 ? '방 목록' : "마이",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            viewModel.currentIndex == 0
                ? IconButton(
                    onPressed: () async {
                      // 필터 페이지로 이동하고, 필터 결과를 기다림
                      final selectedTopicIds =
                          await context.push<List<int>>('/filter');

                      if (selectedTopicIds != null) {
                        // 필터 결과를 사용하여 상태 업데이트
                        viewModel.updateSelectedTopics(selectedTopicIds);
                        // 페이지를 완전히 다시 빌드하여 initState가 호출되도록 함
                        context.replace('/'); // 현재 경로를 다시 로드하여 페이지 새로 빌드
                      }
                    },
                    icon: const Icon(Icons.filter_alt),
                  )
                : Container(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 20, 42, 128),
          onPressed: () {
            context.push('/create');
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: viewModel.currentIndex,
          onTap: viewModel.onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Color(0xFF3D4A7A),
              ),
              label: '홈',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  color: Color(0xFF3D4A7A),
                ),
                label: '마이'),
          ],
        ),
        body: [
          RoomListView(selectedTopicIds: widget.selectedTopicIds),
          const MyRoomView(),
        ].elementAt(viewModel.currentIndex),
      ),
    );
  }
}
