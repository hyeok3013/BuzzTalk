import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alarm_app/src/model/room_model.dart';

class RoomService {
  Future<void> submitRoomDetails(RoomModel roomModel) async {
    final response = await http.post(
      Uri.parse('api'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(roomModel.toJson()),
    );

    if (response.statusCode == 200) {
      print("Room Created");
    } else {
      throw Exception("Failed");
    }
  }
}
