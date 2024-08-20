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
  DateTime? _startTime;
  DateTime? _endTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateRoomViewModel>().fetchTopics();
    });
  }

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
          Consumer<CreateRoomViewModel>(
            builder: (context, viewModel, child) {
              return IconButton(
                icon: Icon(Icons.check),
                onPressed: viewModel.isLoading
                    ? null
                    : () {
                        if (_roomNameController.text.isNotEmpty &&
                            _topicId != null &&
                            _endTime != null) {
                          viewModel.createRoom(
                            roomName: _roomNameController.text,
                            topicId: _topicId!,
                            startTime: _startTime,
                            endTime: _endTime!,
                          );

                          if (viewModel.errorMessage == null) {
                            Navigator.pop(context, true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(viewModel.errorMessage!)),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("모든 필드를 입력해주세요.")),
                          );
                        }
                      },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<CreateRoomViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                if (viewModel.isLoading) CircularProgressIndicator(),
                TextField(
                  controller: _roomNameController,
                  decoration: InputDecoration(labelText: "방 이름"),
                ),
                SizedBox(height: 20),
                DropdownButton<int>(
                  hint: Text("주제를 선택하세요"),
                  value: _topicId,
                  onChanged: (value) {
                    setState(() {
                      _topicId = value;
                    });
                  },
                  items: viewModel.topics.map((topic) {
                    return DropdownMenuItem<int>(
                      value: topic['topicId'], // JSON의 'topicId'를 사용해야 함
                      child:
                          Text(topic['topicName']), // JSON의 'topicName'을 사용해야 함
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final selectedStartTime = await _selectDateTime(context);
                    if (selectedStartTime != null) {
                      setState(() {
                        _startTime = selectedStartTime;
                      });
                    }
                  },
                  child: Text(_startTime != null
                      ? "시작 시간: ${_startTime!.toIso8601String()}"
                      : "시작 시간 선택"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final selectedEndTime = await _selectDateTime(context);
                    if (selectedEndTime != null) {
                      setState(() {
                        _endTime = selectedEndTime;
                      });
                    }
                  },
                  child: Text(_endTime != null
                      ? "종료 시간: ${_endTime!.toIso8601String()}"
                      : "종료 시간 선택"),
                ),
              ],
            );
          },
        ),
      ),
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
