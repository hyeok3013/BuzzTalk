class TopicModel {
  final int topicId;
  final String topicName;

  TopicModel({
    required this.topicId,
    required this.topicName,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      topicId: json['topicId'],
      topicName: json['topicName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'topicId': topicId, 'topicName': topicName};
  }
}
