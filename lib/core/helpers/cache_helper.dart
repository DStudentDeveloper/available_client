import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  CacheHelper._internal();

  static final CacheHelper instance = CacheHelper._internal();

  static const _firstTimerKey = 'not-first-timer';

  late SharedPreferences _prefs;

  bool _initialized = false;

  bool get isInitialized => _initialized;

  void init(SharedPreferences prefs) {
    if (_initialized) return;
    _prefs = prefs;
    _initialized = true;
  }

  Future<void> cacheFirstTimer() async {
    await _prefs.setBool(_firstTimerKey, false);
  }

  bool get isFirstTimer => _prefs.getBool(_firstTimerKey) ?? true;
}
