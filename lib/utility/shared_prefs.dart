import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  static String getString(String key) {
    return instance.getString(key) ?? "";
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = instance;
    return prefs.setString(key, value);
  }

  static int getInt(String key) {
    return instance.getInt(key) ?? 0;
  }

  static Future<bool> setInt(String key, int value) async {
    var prefs = instance;
    return prefs.setInt(key, value);
  }

  static bool getBool(String key) {
    return instance.getBool(key) ?? false;
  }

  static Future<bool> setBool(String key, bool value) async {
    var prefs = instance;
    return prefs.setBool(key, value);
  }

  static List<int> getFavoriteAudios(String key) {
    List<String> mList = instance.getStringList(key) ?? [];
    return mList.map((i) => int.parse(i)).toList();
  }

  static Future<bool> setFavoriteAudios(String key, List<int> mList) async {
    var prefs = instance;
    List<String> stringsList = mList.map((i) => i.toString()).toList();

    return prefs.setStringList(key, stringsList);
  }
}
