import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String userBoxKey = 'user_box';
  static const String hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String userNameKey = 'user_name';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(userBoxKey);
  }

  static Box<dynamic> get _userBox => Hive.box(userBoxKey);

  // Onboarding
  static Future<void> setOnboardingSeen() async {
    await _userBox.put(hasSeenOnboardingKey, true);
  }

  static bool hasSeenOnboarding() {
    return _userBox.get(hasSeenOnboardingKey, defaultValue: false) as bool;
  }

  // User Name
  static Future<void> setUserName(String name) async {
    await _userBox.put(userNameKey, name);
  }

  static String? getUserName() {
    return _userBox.get(userNameKey) as String?;
  }

  static Future<void> clear() async {
    await _userBox.clear();
  }
}
