class RoomModel {
  final String roomId;
  final DateTime startTime;
  final DateTime endTime;
  final int topicId;
  final String playerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoomModel(
      {required this.roomId,
      required this.startTime,
      required this.endTime,
      required this.topicId,
      required this.playerId,
      required this.createdAt,
      required this.updatedAt});

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      roomId: json['roomId'],
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
      'roomId': roomId,
      'startTime': startTime.toIso8601String(),
      'endTime': startTime.toIso8601String(),
      'topicId': topicId,
      'playerId': playerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
