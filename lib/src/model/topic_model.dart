class TopicModel {
<<<<<<< lib/src/model/topic_model.dart
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  TopicModel(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.updatedAt});

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'],
      name: json['name'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
