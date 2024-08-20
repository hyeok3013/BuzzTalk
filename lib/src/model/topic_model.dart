class TopicModel {
  final int topicId;
  final String topicName;

  TopicModel({
    required this.topicId,
    required this.topicName,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      topicId: json['topicId'] ?? 0, // topicId가 null일 경우 기본값 0 사용
      topicName: json['topicName'] ??
          'Unknown', // topicName이 null일 경우 기본값 'Unknown' 사용
    );
  }
}
