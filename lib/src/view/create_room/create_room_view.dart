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
      context.read<CreateRoomViewModel>().fetchTopics(context);
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
        title: const Text("방 만들기"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<CreateRoomViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  if (viewModel.isLoading) const CircularProgressIndicator(),
                  TextField(
                    controller: _roomNameController,
                    decoration: InputDecoration(
                      labelText: "방 이름",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.grey, // 기본 테두리 색상
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color:
                              Color.fromARGB(255, 20, 42, 128), // 포커스 시 테두리 색상
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ), // 텍스트 내부 여백
                    ),
                  ),
                  const SizedBox(height: 20),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey, width: 1.0), // 테두리 색상과 두께 설정
                      borderRadius: BorderRadius.circular(8.0), // 테두리 둥글게 설정
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0), // 내부 여백 추가
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          hint: const Text(
                            "주제를 선택하세요",
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // 힌트 텍스트 bold체
                            ),
                          ),
                          value: _topicId,
                          onChanged: (value) {
                            setState(() {
                              _topicId = value;
                            });
                          },
                          items: viewModel.topics.map((topic) {
                            return DropdownMenuItem<int>(
                              value:
                                  topic['topicId'], // JSON의 'topicId'를 사용해야 함
                              child: Text(
                                topic['topicName'], // JSON의 'topicName'을 사용해야 함
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, // 드롭다운 텍스트 bold체
                                ),
                              ),
                            );
                          }).toList(),
                          isExpanded: true, // 드롭다운이 가득 차도록 설정
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () async {
                      final selectedStartTime = await _selectDateTime(context);
                      if (selectedStartTime != null) {
                        setState(() {
                          _startTime = selectedStartTime;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 20, 42, 128), // 버튼 배경색
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // 둥근 모서리
                      ),
                      minimumSize: const Size(double.infinity, 56), // 버튼 크기 조정
                    ),
                    child: Text(
                      _startTime != null
                          ? "시작 시간: ${_startTime!.toIso8601String()}"
                          : "시작 시간 선택",
                      style: const TextStyle(
                        color: Colors.white, // 텍스트 색상
                        fontWeight: FontWeight.bold, // 텍스트 두께
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final selectedEndTime = await _selectDateTime(context);
                      if (selectedEndTime != null) {
                        setState(() {
                          _endTime = selectedEndTime;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 20, 42, 128), // 버튼 배경색
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // 둥근 모서리
                      ),
                      minimumSize: const Size(double.infinity, 56), // 버튼 크기 조정
                    ),
                    child: Text(
                      _endTime != null
                          ? "종료 시간: ${_endTime!.toIso8601String()}"
                          : "종료 시간 선택",
                      style: const TextStyle(
                        color: Colors.white, // 텍스트 색상
                        fontWeight: FontWeight.bold, // 텍스트 두께
                      ),
                    ),
                  ),
                  const SizedBox(height: 370),
                  ElevatedButton(
                    onPressed: () {
                      if (_roomNameController.text.isNotEmpty &&
                          _topicId != null &&
                          _endTime != null) {
                        context.read<CreateRoomViewModel>().createRoom(
                              roomName: _roomNameController.text,
                              topicId: _topicId!,
                              startTime: _startTime,
                              endTime: _endTime!,
                              context: context,
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("모든 필드를 입력해주세요.")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 20, 42, 128), // 버튼 배경색
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // 둥근 모서리
                      ),
                      minimumSize: const Size(double.infinity, 56), // 버튼 크기 조정
                    ),
                    child: const Text(
                      "방 생성하기",
                      style: TextStyle(
                        color: Colors.white, // 텍스트 색상
                        fontWeight: FontWeight.bold, // 텍스트 두께
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 20, 42, 128), // 선택된 날짜 색상
              onPrimary: Colors.white, // 선택된 날짜 텍스트 색상
              onSurface: Colors.black, // 일반 텍스트 색상
            ),
            dialogBackgroundColor: Colors.white, // 다이얼로그 배경색
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    const Color.fromARGB(255, 20, 42, 128), // "취소" 및 "확인" 버튼 색상
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(255, 20, 42, 128), // 선택된 시간 색상
                onPrimary: Colors.white, // 선택된 시간 텍스트 색상
                onSurface: Colors.black, // 일반 텍스트 색상
              ),
              dialogBackgroundColor: Colors.white, // 다이얼로그 배경색
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(
                      255, 20, 42, 128), // "취소" 및 "확인" 버튼 색상
                ),
              ),
            ),
            child: child!,
          );
        },
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
