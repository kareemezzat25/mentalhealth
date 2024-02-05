import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static const String _tokenKey = 'token';
  static const String _emailKey = 'email';
  static const String _userIdKey = 'userId'; // Add this line

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
    prefs.setString(_userIdKey, userId); // Add this line
  }

  static Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_tokenKey);
    prefs.remove(_emailKey);
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  static Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<String?> getUsername() async {
    try {
      String? email = await getEmail();
      return email ?? "UnknownUser";
    } catch (error) {
      print('Error during getUsername: $error');
      throw Exception('Failed to fetch username');
    }
  }
}
