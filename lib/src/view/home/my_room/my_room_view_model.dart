import 'package:alarm_app/src/model/room_model.dart';
import 'package:alarm_app/src/repository/auth_repository.dart';
import 'package:alarm_app/src/repository/room_repository.dart';
import 'package:alarm_app/src/repository/shared_preferences_repository.dart';
import 'package:alarm_app/src/service/local_notification_service.dart';
import 'package:alarm_app/src/view/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:alarm_app/src/view/auth/chg_pwd_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:alarm_app/src/view/auth/chg_pwd_view_model.dart';

class MyRoomViewModel extends BaseViewModel {
  final AuthRepository authRepository;
  final RoomRepository roomRepository;
  final LocalNotificationService localNotificationService;
  final SharedPreferencesRepository sharedPreferencesRepository;

  List<RoomModel> roomList = [];

  MyRoomViewModel(
      {required this.authRepository,
      required this.roomRepository,
      required this.localNotificationService,
      required this.sharedPreferencesRepository});

  void _showConfirmationSheet({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: const Color(0xFF1C1C1E), // 배경 색상 설정
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 20, 42, 128),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // 확인 버튼 색상 (탈퇴, 로그아웃 등)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> logout(BuildContext context) async {
    _showConfirmationSheet(
      context: context,
      title: '로그아웃',
      message: '정말로 로그아웃하시겠습니까?',
      onConfirm: () async {
        try {
          await authRepository.logout();
          GoRouter.of(context).go('/login');
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to logout: $e")),
          );
        }
      },
    );
  }

  Future<void> deleteAccount(BuildContext context) async {
    _showConfirmationSheet(
      context: context,
      title: '계정 삭제',
      message: '탈퇴 후 계정 복구는 불가합니다.\n정말로 탈퇴하시겠습니까?',
      onConfirm: () async {
        try {
          await authRepository.deletePlayer();
          GoRouter.of(context).go('/login');
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to delete account: $e")),
          );
        }
      },
    );
  }

  void changePassword(BuildContext context) {
    _showConfirmationSheet(
      context: context,
      title: '비밀번호 변경',
      message: '비밀번호를 변경하시겠습니까?',
      onConfirm: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) =>
                  ChangePasswordViewModel(context.read<AuthRepository>()),
              child: const ChangePasswordView(),
            ),
          ),
        );
      },
    );
  }

  Future<void> roomListFetch(List<int>? topicIDList) async {
    //여기서 필터로 저정한 내용을 가져와야 함.
    roomList = await roomRepository.getRoomList(
        topicIds: topicIDList); // 서버에서 방 목록 가져오기

    // 방 목록을 가져온 후 각 방에 대한 예약 정보를 로컬에서 조회하여 설정
    for (RoomModel room in roomList) {
      bool isReserved = sharedPreferencesRepository.isReserved(room);
      print('방 ${room.roomId} 예약 상태: $isReserved'); // 예약 여부 출력 (디버그용)
      room.book = isReserved;

      // 각 방의 예약 정보를 처리하거나 UI에 반영
    }
    // 데이터 변경 후 UI 업데이트
    notifyListeners();
  }

  void bookScheduleChat(RoomModel room) {
    localNotificationService.scheduleNotification(
        id: room.roomId!,
        title: room.roomName,
        body: '채팅이 시작되었습니다.',
        scheduledDateTime: room.startTime!,
        payload: room.roomId.toString());

    sharedPreferencesRepository.saveReservation(room);
    notifyListeners();
  }

  void cancelScheduleChat(RoomModel room) {
    localNotificationService.cancelNotification(room.roomId!);
    sharedPreferencesRepository.removeReservation(room);
    notifyListeners();
  }
}
