class RoomModel {
  final int? roomId;
  final String roomName;
  final DateTime? startTime;
  final DateTime? endTime;
  final int topicId;
  final String? playerId;
  bool book;
  final DateTime? updatedAt;

  RoomModel({
    this.roomId,
    required this.roomName,
    this.startTime,
    this.endTime,
    required this.topicId,
    this.playerId,
    this.book = false, // book의 기본값을 false로 설정
    this.updatedAt,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      roomId: json['room_id'],
      roomName: json['room_name'],
      startTime: json['selectedTime'] != null
          ? DateTime.parse(json['selectedTime'])
          : null, // Parsing DateTime
      endTime: DateTime.parse(json['end_time']), // Parsing DateTime
      topicId: json['topic_id'],
      playerId: json['player_id'],
      book: json['book'] ?? false, // JSON 데이터에서 book 값이 없으면 기본값 false 사용
      updatedAt: DateTime.parse(json['updated_at']), // Parsing DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'startTime':
          startTime?.toIso8601String(), // Converting DateTime to String
      'endTime': endTime?.toIso8601String(), // Converting DateTime to String
      'topicId': topicId,
      'playerId': playerId,
      'book': book,
      'updatedAt':
          updatedAt?.toIso8601String(), // Converting DateTime to String
    };
  }
}
