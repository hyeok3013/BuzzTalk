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
      builder: (context, state) => const TopicFilterView(),
    ),
    GoRoute(
      path: '/chat',
      name: 'chat',
      builder: (context, state) => const ChatView(),
    ),
    GoRoute(
      path: '/create',
      name: 'create',
      builder: (context, state) => const CreateRoomView(),
    ),
  ],
);
