import 'package:alarm_app/src/model/auth_model.dart';
import 'package:alarm_app/src/model/room_model.dart';
import 'package:alarm_app/src/repository/socket_repository.dart';
import 'package:alarm_app/src/view/base_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:alarm_app/src/view/chat/chat_view_model.dart';

class ChatView extends StatelessWidget {
  final RoomModel roomModel;
  const ChatView({super.key, required this.roomModel});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: ChatViewModel(
        socketRepository: context.read(),
        roomModel: roomModel,
        authModel: context.read<AuthModel>(),
      ),
      builder: (BuildContext context, ChatViewModel viewModel) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            viewModel.roomModel.roomName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              viewModel.exitRoom();
              context.pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                controller: viewModel.scrollController,
                reverse: true,
                itemCount: viewModel.messages.length,
                itemBuilder: (context, index) {
                  final messageData = viewModel.messages[index];
                  final isMine = messageData['isMine'] as bool;

                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 15,
                      top: 8,
                      bottom: 8,
                      left: 15,
                    ),
                    child: Align(
                      alignment: isMine
                          ? Alignment.centerRight // 내 메시지는 오른쪽
                          : Alignment.centerLeft, // 상대는 왼쪽
                      child: Column(
                        crossAxisAlignment: isMine
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${messageData['playerId']}', // playerId 표시
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: isMine
                                  ? const Color.fromARGB(255, 20, 42, 128)
                                  : const Color(0xFFF2F7FB),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              messageData['message']!,
                              style: TextStyle(
                                color: isMine ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: viewModel.controller,
                    decoration: InputDecoration(
                      hintText: '메시지 입력',
                      border: InputBorder.none, // 기본 테두리를 없앰
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // 활성화된 상태의 테두리 색상
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(
                                255, 20, 42, 128)), // 포커스된 상태의 테두리 색상
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Color.fromARGB(255, 20, 42, 128),
                        ),
                        onPressed: viewModel.sendMessage,
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
