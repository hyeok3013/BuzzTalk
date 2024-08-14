import 'package:alarm_app/src/model/topic_model.dart';
import 'package:alarm_app/src/service/topic_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopicFilterView extends StatefulWidget {
  final int? selectedTopicId;

  const TopicFilterView({super.key, this.selectedTopicId});

  @override
  State<TopicFilterView> createState() => _TopicFilterViewState();
}

class _TopicFilterViewState extends State<TopicFilterView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
