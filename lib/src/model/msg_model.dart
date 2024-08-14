class MsgModel {
  final int id;
  final String uuid;
  final DateTime createdAt;
  final DateTime updatedAt;

  MsgModel(
      {required this.id,
      required this.uuid,
      required this.createdAt,
      required this.updatedAt});
//s
  factory MsgModel.fromJson(Map<String, dynamic> json) {
    return MsgModel(
      id: json['id'],
      uuid: json['uuid'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
