import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _keyProfileComplete = 'profile_complete';

  static Future<void> setProfileComplete(bool complete) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyProfileComplete, complete);
  }

  static Future<bool> isProfileComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyProfileComplete) ?? false;
  }
}
