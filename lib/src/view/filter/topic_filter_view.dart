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
    super.initState();
    topicFilterViewModel.loadTopics(context); // BuildContext 전달
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
              context.replace('/');
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: viewModel.topics.length,
                  itemBuilder: (context, index) {
                    final topic = viewModel.topics[index];
                    final isSelected =
                        viewModel.selectedTopicIds.contains(topic.topicId);
                    final topicRoomCount =
                        viewModel.topicRoomCounts[topic.topicId] ?? 0;

                    return GestureDetector(
                      onTap: () => viewModel.onTopicTap(topic.topicId),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              color: isSelected
                                  ? const Color.fromARGB(255, 20, 42, 128)
                                  : Colors.transparent,
                            ),
                            width: 80,
                            height: 80,
                            child: Center(
                              child: Text(
                                topic.topicName,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
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
                                  '$topicRoomCount',
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
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 20, 42, 128), // 배경색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 둥근 모서리
                  ),
                  minimumSize: const Size(double.infinity, 56), // 버튼 크기
                ),
                onPressed: () {
                  context.replace('/', extra: viewModel.selectedTopicIds);
                  print('선택 topic id: ${viewModel.selectedTopicIds}');
                },
                child: const Text(
                  '선택 완료',
                  style: TextStyle(
                    color: Colors.white, // 텍스트 색상
                    fontWeight: FontWeight.bold, // 텍스트 두께
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
