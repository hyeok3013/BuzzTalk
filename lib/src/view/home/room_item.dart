import 'package:alarm_app/src/model/topic_model.dart';
import 'package:alarm_app/src/service/my_room_service.dart';
import 'package:alarm_app/src/service/topic_service.dart';
import 'package:alarm_app/src/model/room_model.dart';
import 'package:alarm_app/src/theme/palette.dart';
import 'package:alarm_app/util/helper/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:another_flushbar/flushbar.dart';

class RoomItem extends StatelessWidget {
  final RoomModel room;
  final List<TopicModel> topicList = [];
  final VoidCallback onReserve;
  final VoidCallback onCancel;

  RoomItem({
    super.key,
    required this.room,
    required this.onReserve,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('주제: ${getTopicNameByRoomId(room.topicId)}'),
              const SizedBox(height: 5),
              Text('방이름: ${room.roomName}'),
              const SizedBox(height: 15),
              Text('시작: ${DateTimeHelper.formatDateTime(room.startTime!)}'),
              Text('종료: ${DateTimeHelper.formatDateTime(room.endTime)}'),
            ],
          ),
          room.startTime!
                  .isAfter(DateTime.now().toUtc().add(const Duration(hours: 9)))

              /// 현재 시간보다 빠름
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 20, 42, 128), // 배경색
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (room.book) {
                      onCancel(); // 예약 취소 동작
                      showFlushbar(context, '방 예약을 취소했습니다.');
                    } else {
                      onReserve(); // 예약 동작
                      showFlushbar(context, '방 예약이 완료됐습니다.');
                    }
                  },
                  child: room.book
                      ? const Text('취소')
                      : const Text(
                          '예약',
                        ),
                )

              /// 현재 시간보다 느림
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 20, 42, 128), // 배경색
                      foregroundColor: Colors.white),
                  onPressed: () {
                    context.push('/chat', extra: room);
                  },
                  child: const Text(
                    '참여',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  String getTopicNameByRoomId(int topicId) {
    try {
      // topicList에서 room의 topicId와 일치하는 TopicModel의 topicName 반환
      return topicList
          .firstWhere((topic) => topic.topicId == topicId)
          .topicName;
    } catch (e) {
      return 'Unknown Topic'; // 일치하는 topicId가 없을 경우 기본값 반환
    }
  }

  void showFlushbar(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 2),
      backgroundColor: const Color.fromARGB(255, 20, 42, 128),
      margin: const EdgeInsets.all(8.0),
      borderRadius: BorderRadius.circular(8.0),
    ).show(context);
  }
}
