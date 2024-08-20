import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alarm_app/src/view/create_room/create_room_view_model.dart';

class CreateRoomView extends StatefulWidget {
  const CreateRoomView({super.key});

  @override
  State<CreateRoomView> createState() => _CreateRoomViewState();
}

class _CreateRoomViewState extends State<CreateRoomView> {
  final TextEditingController _roomNameController = TextEditingController();
  int? _topicId;
  DateTime? _selectedTime;

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("방 만들기"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_roomNameController.text.isNotEmpty && _topicId != null) {
                context.read<CreateRoomViewModel>().createRoom(
                      roomName: _roomNameController.text,
                      topicId: _topicId!,
                      selectedTime: _selectedTime, // 선택적
                    );

                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("모든 필드를 입력해주세요.")),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _roomNameController,
              decoration: InputDecoration(labelText: "방 이름"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final selectedTopic = await _showTopicSelectionDialog(context);
                if (selectedTopic != null) {
                  setState(() {
                    _topicId = int.parse(selectedTopic);
                  });
                }
              },
              child: Text(_topicId != null ? "토픽 $_topicId 선택됨" : "주제 선택"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final selectedTime = await _selectDateTime(context);
                if (selectedTime != null) {
                  setState(() {
                    _selectedTime = selectedTime;
                  });
                }
              },
              child: Text(_selectedTime != null
                  ? _selectedTime!.toIso8601String()
                  : "시간 선택"),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showTopicSelectionDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("주제를 선택하세요."),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop("1"); // 예: 토픽 1의 ID
                },
                child: Text("토픽1"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop("2"); // 예: 토픽 2의 ID
                },
                child: Text("토픽2"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<DateTime?> _selectDateTime(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (selectedTime != null) {
        return DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }
    return null;
  }
}
