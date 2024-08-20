class AuthModel {
  final String playerId;
  final String password;

  AuthModel({
    required this.playerId,
    required this.password,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      playerId: json['playerId'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'password': password,
    };
  }
}
