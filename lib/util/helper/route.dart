import 'package:alarm_app/src/model/room_model.dart';
import 'package:alarm_app/src/view/auth/login_view.dart';
import 'package:alarm_app/src/view/chat/chat_view.dart';
import 'package:alarm_app/src/view/home/room_list/room_list_view.dart';
import 'package:alarm_app/src/view/create_room//create_room_view.dart';
import 'package:alarm_app/src/view/home//home_view.dart';
import 'package:alarm_app/src/view/filter//topic_filter_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  ///로그인 로직 나중에 추가, 로그인이 되어있으면 /로 아니면 로그인 페이지로
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: '/filter',
      name: 'filter',
      builder: (context, state) => TopicFilterView(),
    ),
    GoRoute(
      path: '/chat',
      name: 'chat',
      builder: (context, state) {
        // 전달된 값을 state.extra로 받음
        final RoomModel roomModel = state.extra as RoomModel;

        return ChatView(
          roomModel: roomModel, // 전달된 roomModel 사용
        );
      },
    ),
    GoRoute(
      path: '/create',
      name: 'create',
      builder: (context, state) => const CreateRoomView(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => Login(),
    ),
  ],
);
