import 'package:alarm_app/src/service/my_room_service.dart';
import 'package:alarm_app/src/service/topic_service.dart';
import 'package:alarm_app/src/model/room_model.dart';
import 'package:alarm_app/src/theme/palette.dart';
import 'package:alarm_app/util/helper/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:alarm_app/src/model/room_model.dart';

class RoomItem extends StatelessWidget {
  final RoomModel room;
  final VoidCallback onReserve;
  final VoidCallback onCancel;

  const RoomItem({
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
              Text('주제: ${room.topicId}'),
              const SizedBox(height: 5),
              Text('방이름: ${room.roomId}'),
              const SizedBox(height: 15),
              Text('시작: ${DateTimeHelper.formatDateTime(room.startTime)}'),
              Text('종료: ${DateTimeHelper.formatDateTime(room.endTime)}'),
            ],
          ),
          room.startTime.isAfter(DateTime.now().toUtc().add(Duration(hours: 9)))

              ///현재 시간보다 빠름
              ? ElevatedButton(
                  onPressed: room.book ? onCancel : onReserve,
                  child: room.book ? Text('취소') : Text('예약'),
                )

              ///현재 시간보다 느림
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // 배경색
                      foregroundColor: Colors.white),
                  onPressed: () {
                    context.push('/chat', extra: room);
                  },
                  child: const Text('참여'),
                )
        ],
      ),
    );
  }
}
