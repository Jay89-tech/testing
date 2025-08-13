// lib/services/local/shared_preferences_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesService {
  static SharedPreferences? _preferences;
  
  // Keys
  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userRoleKey = 'user_role';
  static const String _userSkillsKey = 'user_skills';
  static const String _appThemeKey = 'app_theme';
  static const String _languageKey = 'language';
  static const String _firstLaunchKey = 'first_launch';
  static const String _lastSyncKey = 'last_sync';

  // Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance {
    if (_preferences == null) {
      throw Exception('SharedPreferences not initialized. Call init() first.');
    }
    return _preferences!;
  }

  // User Authentication Methods
  static Future<bool> setLoggedIn(bool isLoggedIn) async {
    return await instance.setBool(_isLoggedInKey, isLoggedIn);
  }

  static bool isLoggedIn() {
    return instance.getBool(_isLoggedInKey) ?? false;
  }

  // User Data Methods
  static Future<bool> setUserData(Map<String, dynamic> userData) async {
    final jsonString = json.encode(userData);
    return await instance.setString(_userDataKey, jsonString);
  }

  static Map<String, dynamic>? getUserData() {
    final jsonString = instance.getString(_userDataKey);
    if (jsonString != null) {
      return Map<String, dynamic>.from(json.decode(jsonString));
    }
    return null;
  }

  // User Role Methods
  static Future<bool> setUserRole(String role) async {
    return await instance.setString(_userRoleKey, role);
  }

  static String getUserRole() {
    return instance.getString(_userRoleKey) ?? 'user';
  }

  static bool isAdmin() {
    return getUserRole() == 'admin';
  }

  // User Skills Methods
  static Future<bool> setUserSkills(List<Map<String, dynamic>> skills) async {
    final jsonString = json.encode(skills);
    return await instance.setString(_userSkillsKey, jsonString);
  }

  static List<Map<String, dynamic>> getUserSkills() {
    final jsonString = instance.getString(_userSkillsKey);
    if (jsonString != null) {
      final List<dynamic> skillsList = json.decode(jsonString);
      return skillsList.map((skill) => Map<String, dynamic>.from(skill)).toList();
    }
    return [];
  }

  // App Settings Methods
  static Future<bool> setAppTheme(String theme) async {
    return await instance.setString(_appThemeKey, theme);
  }

  static String getAppTheme() {
    return instance.getString(_appThemeKey) ?? 'light';
  }

  static Future<bool> setLanguage(String language) async {
    return await instance.setString(_languageKey, language);
  }

  static String getLanguage() {
    return instance.getString(_languageKey) ?? 'en';
  }

  // First Launch Methods
  static Future<bool> setFirstLaunch(bool isFirstLaunch) async {
    return await instance.setBool(_firstLaunchKey, isFirstLaunch);
  }

  static bool isFirstLaunch() {
    return instance.getBool(_firstLaunchKey) ?? true;
  }

  // Last Sync Methods
  static Future<bool> setLastSyncTime(DateTime dateTime) async {
    return await instance.setString(_lastSyncKey, dateTime.toIso8601String());
  }

  static DateTime? getLastSyncTime() {
    final dateString = instance.getString(_lastSyncKey);
    if (dateString != null) {
      return DateTime.parse(dateString);
    }
    return null;
  }

  // Generic Methods
  static Future<bool> setString(String key, String value) async {
    return await instance.setString(key, value);
  }

  static String? getString(String key) {
    return instance.getString(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await instance.setBool(key, value);
  }

  static bool? getBool(String key) {
    return instance.getBool(key);
  }

  static Future<bool> setInt(String key, int value) async {
    return await instance.setInt(key, value);
  }

  static int? getInt(String key) {
    return instance.getInt(key);
  }

  static Future<bool> setDouble(String key, double value) async {
    return await instance.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return instance.getDouble(key);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    return await instance.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return instance.getStringList(key);
  }

  // Clear Methods
  static Future<bool> remove(String key) async {
    return await instance.remove(key);
  }

  static Future<bool> clearUserData() async {
    await instance.remove(_userDataKey);
    await instance.remove(_isLoggedInKey);
    await instance.remove(_userRoleKey);
    await instance.remove(_userSkillsKey);
    return true;
  }

  static Future<bool> clearAll() async {
    return await instance.clear();
  }

  // Utility Methods
  static bool containsKey(String key) {
    return instance.containsKey(key);
  }

  static Set<String> getKeys() {
    return instance.getKeys();
  }

  static Future<void> reload() async {
    await instance.reload();
  }
}