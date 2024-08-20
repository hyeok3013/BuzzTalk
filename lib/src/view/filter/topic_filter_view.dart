import 'package:alarm_app/src/repository/topic_repository.dart';
import 'package:alarm_app/src/view/base_view.dart';
import 'package:alarm_app/src/view/filter/topic_filter_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TopicFilterView extends StatefulWidget {
  const TopicFilterView({super.key});

  @override
  State<TopicFilterView> createState() => _TopicFilterViewState();
}

class _TopicFilterViewState extends State<TopicFilterView> {
  late final TopicFilterViewModel topicFilterViewModel =
      TopicFilterViewModel(topicRepository: context.read());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    topicFilterViewModel.loadTopics();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: topicFilterViewModel,
      builder: (BuildContext context, TopicFilterViewModel viewModel) =>
          Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('주제별 필터'),
          leading: IconButton(
            onPressed: () {
              //필터 창 닫기
              // context.go('/');
              context.pop();
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.pop(viewModel.selectedTopicIds);
                print('선택 topic id: ${viewModel.selectedTopicIds}');
              },
              icon: const Icon(
                Icons.check,
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, //한 열에 얼마나 널을 것인지
                  childAspectRatio: 1, //child 가로 세로 비율
                  crossAxisSpacing: 10, //열 간의 간격
                  mainAxisSpacing: 10, //행 간의 간격
                ),
                itemCount: viewModel.topics.length,
                itemBuilder: (context, index) {
                  final topic = viewModel.topics[index];
                  final isSelected =
                      viewModel.selectedTopicIds.contains(topic.topicId);
                  final topicRoomCount =
                      viewModel.topicRoomCounts[topic.topicId] ?? 0;

                  return GestureDetector(
                    onTap: () => viewModel
                        .onTopicTap(topic.topicId), // 토픽 1 선택 시 ID 1 전달
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            color: isSelected // 선택된 상태 확인
                                ? Colors.purple
                                : Colors.transparent,
                          ),
                          width: 80,
                          height: 80,
                          child: Center(
                            child: Text(
                              topic.topicName, //topicName
                            ),
                          ),
                        ),
                        Positioned(
                          top: 54,
                          left: 65,
                          child: Container(
                            width: 15,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$topicRoomCount', //토픽의 개수
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
