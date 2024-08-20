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
        authModel: AuthModel(playerId: '123', password: '123'),
      ),
      builder: (BuildContext context, ChatViewModel viewModel) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(viewModel.roomModel.roomName),
          leading: IconButton(
            onPressed: () {
              viewModel.exitRoom();
              context.pop();
            },
            icon: Icon(Icons.arrow_back),
          ), // ViewModel에서 roomId를 가져옴
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: viewModel.messages.length,
                itemBuilder: (context, index) {
                  final messageData = viewModel.messages[index];
                  final isMine = messageData['isMine'] as bool;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
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
                            '게스트#${messageData['playerId']}', // playerId 표시
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: isMine ? Colors.blue : Colors.grey,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              messageData['message']!,
                              style: const TextStyle(color: Colors.white),
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
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: viewModel.controller,
                      decoration: InputDecoration(
                        hintText: '메시지 입력',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: viewModel.sendMessage,
                    child: const Text('Send'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
