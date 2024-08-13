class RoomModel {
<<<<<<< lib/src/model/room_model.dart
  final int id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final int topicId;
  final int playerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoomModel(
      {required this.id,
      required this.name,
      required this.startTime,
      required this.endTime,
      required this.topicId,
      required this.playerId,
      required this.createdAt,
      required this.updatedAt});

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      name: json['name'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      topicId: json['topicId'],
      playerId: json['playerId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime.toIso8601String(),
      'endTime': startTime.toIso8601String(),
      'topicId': topicId,
      'playerId': playerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
