import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static final SharedPrefs _instance = SharedPrefs._internal();
  late SharedPreferences _prefs;

  // Private constructor
  SharedPrefs._internal();

  // Factory constructor
  factory SharedPrefs() {
    return _instance;
  }

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Get value
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // Set value
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  // Remove value
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}
