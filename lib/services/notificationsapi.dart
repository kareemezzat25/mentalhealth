import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mentalhealthh/authentication/auth.dart';

class NotificationApi {
  static Future<List<Map<String, dynamic>>> fetchNotifications(
      int pageNumber, int pageSize) async {
    String? token = await Auth.getToken();

    final url = Uri.parse(
        'https://nexus-api-h3ik.onrender.com/api/notifications/users/me?pageNumber=$pageNumber&pageSize=$pageSize');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to fetch notifications');
    }
  }

  static Future<void> markAsRead(int id) async {
    String? token = await Auth.getToken();

    final url = Uri.parse(
        'https://nexus-api-h3ik.onrender.com/api/notifications/$id/read');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }

  static Future<void> markAllAsRead() async {
    String? token = await Auth.getToken();

    final url = Uri.parse(
        'https://nexus-api-h3ik.onrender.com/api/notifications/users/me/read');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark all notifications as read');
    }
  }
}
