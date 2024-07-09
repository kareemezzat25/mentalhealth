import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/services/notificationsapi.dart';
import 'package:mentalhealthh/services/postsApi.dart';
import 'package:mentalhealthh/views/appointments/Appointmentsview.dart';
import 'package:mentalhealthh/views/posts/PostComment.dart';
import 'package:mentalhealthh/providers/notification_count_provider.dart'; // Import the provider
import 'package:mentalhealthh/widgets/CommonDrawer.dart';
import 'package:provider/provider.dart'; // Import provider package

class Notificationsview extends StatefulWidget {
  final String userId;

  const Notificationsview({required this.userId});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<Notificationsview> {
  List<Map<String, dynamic>> notifications = [];
  List<Map<String, dynamic>> filteredNotifications = [];
  bool isLoading = true;
  bool showUnreadOnly = false;
  int pageNumber = 1;
  int pageSize = 10;
  bool hasMoreData = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchNotifications();
    _updateUnreadCount(); // Initial fetch for unread count

    // Attach listener to detect scroll end
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Map<String, dynamic>> data =
          await NotificationApi.fetchNotifications(pageNumber, pageSize);
      setState(() {
        notifications.addAll(data);
        filteredNotifications = notifications;
        if (data.isEmpty) {
          hasMoreData = false;
        } else {
          pageNumber++;
        }
        isLoading = false;

        // Update unread count
        _updateUnreadCount(); // Update unread count after fetching notifications
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Failed to fetch notifications: $e');
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await NotificationApi.markAsRead(id);
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

        // Update unread count
        _updateUnreadCount();
      });
    } catch (e) {
      print('Failed to mark notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await NotificationApi.markAllAsRead();
      setState(() {
        notifications = notifications.map((notification) {
          notification['isRead'] = true;
          return notification;
        }).toList();
        filteredNotifications = notifications;

        // Update unread count
        _updateUnreadCount();
      });
    } catch (e) {
      print('Failed to mark all notifications as read: $e');
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

  Future<void> _handleNotificationTap(Map<String, dynamic> notification) async {
    if (!notification['isRead']) {
      markAsRead(notification['id']);
    }

    // Navigate based on notification type
    if (notification['type'] == 'Reply') {
      int postId = notification['resources']['postId'];
      int commentId = notification['resources']['commentId'];
      int replyId = notification['resources']['replyId'];
      try {
        // Attempt to fetch post details
        Map<String, dynamic> postDetails =
            await PostsApi.fetchPostDetails(postId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostComment(
              postId: postId,
            ),
          ),
        );
      } catch (e) {
        // Post details fetch failed (post deleted)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Post Deleted'),
              content:
                  Text('The post you are trying to view has been deleted.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else if (notification['type'] == 'Comment') {
      int postId = notification['resources']['postId'];
      try {
        // Attempt to fetch post details
        Map<String, dynamic> postDetails =
            await PostsApi.fetchPostDetails(postId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostComment(
              postId: postId,
            ),
          ),
        );
      } catch (e) {
        // Post details fetch failed (post deleted)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Post Deleted'),
              content:
                  Text('The post you are trying to view has been deleted.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else if (notification['type'] == 'AppointmentConfirmation' ||
        notification['type'] == 'AppointmentRejection') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Appointmentsview(userId: widget.userId)),
      );
    }
  }

  void loadNextPage() {
    if (hasMoreData && !isLoading) {
      fetchNotifications();
    }
  }

  void _updateUnreadCount() {
    // Calculate unread count
    int unreadCount = notifications.where((n) => !n['isRead']).length;

    // Update provider
    Provider.of<NotificationCountProvider>(context, listen: false)
        .updateUnreadCount(unreadCount);
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
      drawer: CommonDrawer(userId: widget.userId),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: filteredNotifications.length + 1,
              itemBuilder: (context, index) {
                if (index < filteredNotifications.length) {
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
                            padding: const EdgeInsets.only(left: 48.0),
                            child: Text('$formattedDateTime'),
                          ),
                        ],
                      ),
                      trailing: notification['isRead']
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : Icon(Icons.check_circle_outline,
                              color: Colors.grey),
                      onTap: () {
                        _handleNotificationTap(notification);
                      },
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
    );
  }
}
