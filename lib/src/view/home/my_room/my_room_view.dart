import 'package:alarm_app/src/repository/auth_repository.dart';
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
  late final MyRoomViewModel myRoomViewModel = MyRoomViewModel(
    authRepository: context.read<AuthRepository>(),
    roomRepository: context.read(),
    localNotificationService: context.read(),
    sharedPreferencesRepository: context.read(),
  );

  @override
  void initState() {
    super.initState();
    myRoomViewModel.roomListFetch(null);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => myRoomViewModel,
      child: Consumer<MyRoomViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () => viewModel.logout(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          const Color.fromARGB(255, 20, 42, 128), // 텍스트 색상
                      minimumSize: const Size.fromHeight(48), // 버튼의 최소 높이 설정
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // 버튼 모서리 둥글게 설정
                      ),
                    ),
                    child: const SizedBox(
                      width: double.infinity, // 버튼의 너비를 부모 위젯의 최대 너비로 확장
                      child: Center(
                        child: Text(
                          "로그아웃",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.changePassword(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          const Color.fromARGB(255, 20, 42, 128), // 텍스트 색상
                      minimumSize: const Size.fromHeight(48), // 버튼의 최소 높이 설정
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // 버튼 모서리 둥글게 설정
                      ),
                    ),
                    child: const SizedBox(
                      width: double.infinity, // 버튼의 너비를 부모 위젯의 최대 너비로 확장
                      child: Center(
                        child: Text(
                          "비밀번호 변경",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.deleteAccount(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          const Color.fromARGB(255, 20, 42, 128), // 텍스트 색상
                      minimumSize: const Size.fromHeight(48), // 버튼의 최소 높이 설정
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // 버튼 모서리 둥글게 설정
                      ),
                    ),
                    child: const SizedBox(
                      width: double.infinity, // 버튼의 너비를 부모 위젯의 최대 너비로 확장
                      child: Center(
                        child: Text(
                          "계정 삭제",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(),

                  /// 내가 예약한 목록 확인
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          viewModel.roomList.where((room) => room.book).length,
                      itemBuilder: (context, index) {
                        final room = viewModel.roomList
                            .where((room) => room.book)
                            .toList()
                            .reversed
                            .toList()[index];

                        return RoomItem(
                          room: room,
                          onReserve: () => viewModel.bookScheduleChat(room),
                          onCancel: () => viewModel.cancelScheduleChat(room),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
