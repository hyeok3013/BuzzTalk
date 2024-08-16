import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  final SharedPreferences prefs;

  SharedPreferencesRepository(this.prefs);

  Future<void> saveReservation(int roomId) async {
    await prefs.setBool(roomId.toString(), true);
  }

  bool isReserved(int roomId) {
    return prefs.getBool(roomId.toString()) ?? false;
  }

  Future<void> removeReservation(int roomId) async {
    await prefs.remove(roomId.toString());
  }
}
