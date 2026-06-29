import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static late SharedPreferences _prefs;

  // Inisialisasi wajib dipanggil di main.dart sebelum runApp()
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Kumpulan Key (Biar gak ada typo lagi!) ---
  static const String keyAuthToken = "auth_token";
  static const String keyUserRole = "user_role"; // admin, siswa, guru, teknisi
  static const String keyUserId = "user_id";
  static const String keyIsLoggedIn = "is_logged_in";

  // --- Wrapper Generic (Bisa simpan apa aja) ---
  static Future<bool> setString(String key, String value) => _prefs.setString(key, value);
  static String getString(String key, {String def = ""}) => _prefs.getString(key) ?? def;

  static Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  static bool getBool(String key, {bool def = false}) => _prefs.getBool(key) ?? def;

  static Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  static int getInt(String key, {int def = 0}) => _prefs.getInt(key) ?? def;

  // --- Fungsi Khusus Role (Biar rapi) ---
  static Future<void> saveUserSession({
    required String token,
    required String role,
    required String userId,
  }) async {
    await _prefs.setString(keyAuthToken, token);
    await _prefs.setString(keyUserRole, role);
    await _prefs.setString(keyUserId, userId);
    await _prefs.setBool(keyIsLoggedIn, true);
  }

  static Future<void> clearSession() async {
    await _prefs.clear();
  }
}