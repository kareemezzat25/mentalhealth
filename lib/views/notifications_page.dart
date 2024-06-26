import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:mentalhealthh/authentication/auth.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [];
  List<Map<String, dynamic>> filteredNotifications = [];
  bool isLoading = true;
  bool showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    String? token = await Auth.getToken();

    final url = Uri.parse(
        'https://nexus-api-h3ik.onrender.com/api/notifications/users/me?pageNumber=1&pageSize=10');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        notifications =
            data.map((item) => item as Map<String, dynamic>).toList();
        filteredNotifications = notifications;
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
      print('Failed to fetch notifications');
    }
  }

  Future<void> markAsRead(int id) async {
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

    if (response.statusCode == 200) {
      setState(() {
        notifications = notifications.map((notification) {
          if (notification['id'] == id) {
            notification['isRead'] = true;
          }
          return notification;
        }).toList();
        if (showUnreadOnly) {
          filteredNotifications = notifications
              .where((notification) => !notification['isRead'])
              .toList();
        } else {
          filteredNotifications = notifications;
        }
      });
    } else {
      print('Failed to mark notification as read');
    }
  }

  Future<void> markAllAsRead() async {
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

    if (response.statusCode == 200) {
      setState(() {
        notifications = notifications.map((notification) {
          notification['isRead'] = true;
          return notification;
        }).toList();
        filteredNotifications = notifications;
      });
    } else {
      print('Failed to mark all notifications as read');
    }
  }

  void toggleUnreadOnly() {
    setState(() {
      showUnreadOnly = !showUnreadOnly;
      if (showUnreadOnly) {
        filteredNotifications = notifications
            .where((notification) => !notification['isRead'])
            .toList();
      } else {
        filteredNotifications = notifications;
      }
    });
  }

  String _formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final String formattedDate =
        DateFormat('d/M/y').format(dateTime); // e.g., 26/6/2024
    final String formattedTime =
        DateFormat.jm().format(dateTime); // e.g., 6:00 AM
    return '$formattedDate at $formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          TextButton(
            onPressed: markAllAsRead,
            child: Text(
              'Mark All as Read',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: toggleUnreadOnly,
            child: Text(
              showUnreadOnly ? 'Show All' : 'Unread Only',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredNotifications.length,
              itemBuilder: (context, index) {
                final notification = filteredNotifications[index];
                final formattedDateTime =
                    _formatDateTime(notification['dateCreated']);

                return Container(
                  color: notification['isRead']
                      ? Colors.purple.shade50
                      : Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(notification['notifierPhotoUrl']),
                    ),
                    title: Text(notification['notifierUserName']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification['message'],
                          style: TextStyle(fontSize: 17),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text('$formattedDateTime'),
                        ),
                      ],
                    ),
                    trailing: notification['isRead']
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.check_circle_outline, color: Colors.grey),
                    onTap: () {
                      if (!notification['isRead']) {
                        markAsRead(notification['id']);
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
