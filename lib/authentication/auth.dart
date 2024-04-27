import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static const String _tokenKey = 'token';
  static const String _emailKey = 'email';
  static const String _userIdKey = 'userId';
  static const String _userNameKey = 'userName';
  static const String _photoUrlKey = 'photoUrl'; 

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> setToken(
      String token, String email, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_tokenKey, token);
    prefs.setString(_emailKey, email);
    prefs.setString(_userIdKey, userId);
  }

  static Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_tokenKey);
    prefs.remove(_emailKey);
    prefs.remove(_userIdKey);
    prefs.remove(_userNameKey);
    prefs.remove(_photoUrlKey); // Add this line to clear photo URL
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  static Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<void> setUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_userNameKey, userName);
  }

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  static Future<void> setPhotoUrl(String photoUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_photoUrlKey, photoUrl);
  }

  static Future<String?> getPhotoUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_photoUrlKey);
  }
}
