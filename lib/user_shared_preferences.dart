import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static late SharedPreferences preferences;

  static Future init() async =>
      preferences = await SharedPreferences.getInstance();

  static Future setTranscribes(List<String> widgets) async =>
      await preferences.setStringList('transcribes', widgets);

  static List<String>? getTranscribes() =>
      preferences.getStringList('transcribes');
}
