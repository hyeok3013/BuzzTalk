import 'package:alarm_app/src/model/room_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  final SharedPreferences prefs;

  SharedPreferencesRepository(this.prefs);

  Future<void> saveReservation(RoomModel room) async {
    room.book = true;
    await prefs.setBool(room.roomId.toString(), room.book);
  }

  bool isReserved(RoomModel room) {
    return prefs.getBool(room.roomId.toString()) ?? false;
  }

  Future<void> removeReservation(RoomModel room) async {
    room.book = false;
    await prefs.remove(room.roomId.toString());
  }
}
